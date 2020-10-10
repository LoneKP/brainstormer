class BrainstormChannel < ApplicationCable::Channel
  TIME_IN_TIMER = 600

  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    stream_from "brainstorm-#{params[:token]}"
    add_to_list_and_transmit!
  end

  def unsubscribed
    remove_from_list_and_transmit!
  end

  def update_name
    transmit_list!
  end

  private

  def add_to_list_and_transmit!
    set_guest_name_if_user_has_no_name
    REDIS.hset brainstorm_key, session_id, Time.now
    transmit_list!
  end

  def remove_from_list_and_transmit!
    REDIS.hdel brainstorm_key, session_id
    transmit_list!
  end

  def set_guest_name_if_user_has_no_name
    if REDIS.get(session_id).nil?
      REDIS.sadd "no_user_name", session_id
      REDIS.set session_id, "GUEST"
    end
  end

  def transmit_list!
    users = REDIS.hgetall(brainstorm_key).keys

    names = []
    initials = []
    user_ids = []
    users.each do |user_id|
      unless last_user_activity_more_than_one_hour_ago?(user_id)
        name = REDIS.get(user_id)
        names << name
        user_ids << user_id
        initials << name.split(nil,2).map(&:first).join.upcase
      end
    end

    data = {
      event: "transmit_list",
      users: names,
      initials: initials,
      user_ids: user_ids,
      no_user_names: REDIS.smembers("no_user_name"),
      timer_status: timer_status,
      facilitator: REDIS.get(brainstorm_facilitator_key)
    }

    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}", data)
  end

  def timer_status
    if REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp").nil?
      return "ready_to_start_timer"
    elsif timer_time_elapsed_in_seconds > TIME_IN_TIMER
      return "time_has_run_out"
    else
      return timer_time_elapsed_in_seconds
    end
  end

  def timer_time_elapsed_in_seconds
    Time.now.to_i - DateTime.parse(REDIS.hget(brainstorm_timer_running_key, "timer_start_timestamp")).to_i
  end

  def last_user_activity_more_than_one_hour_ago?(user_id)
    DateTime.parse(REDIS.hget(brainstorm_key, user_id)) < Time.now-1.hour
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def brainstorm_facilitator_key
    "brainstorm_facilitator_#{@brainstorm.token}"
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{@brainstorm.token}"
  end
end
