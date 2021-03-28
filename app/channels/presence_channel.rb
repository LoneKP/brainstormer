class PresenceChannel < ApplicationCable::Channel

  def subscribed
    @brainstorm = Brainstorm.find_by(token: params[:token])
    stream_from "brainstorm-#{params[:token]}-presence"
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
    set_random_name_if_user_has_no_name
    REDIS.hset brainstorm_key, session_id, Time.now
    transmit_list!
  end

  def remove_from_list_and_transmit!
    REDIS.hdel brainstorm_key, session_id
    transmit_list!
  end

  def set_random_name_if_user_has_no_name
    if REDIS.get(session_id).nil?
      REDIS.set session_id, generate_random_temporary_user_name
    end
  end

  def transmit_list!
    users = REDIS.hgetall(brainstorm_key).keys

    names = []
    initials = []
    user_ids = []
    done_voting_list = []
    users.each do |user_id|
      unless last_user_activity_more_than_one_hour_ago?(user_id)
        name = REDIS.get(user_id)
        done_voting = REDIS.hget(done_voting_brainstorm_status, "#{user_id}")
        names << name
        user_ids << user_id
        initials << name.split(nil,2).map(&:first).join.upcase
        done_voting_list << done_voting
      end
    end

    data = {
      event: "transmit_presence_list",
      users: names,
      initials: initials,
      user_ids: user_ids,
      done_voting_list: done_voting_list
    }

    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-presence", data)
  end

  def last_user_activity_more_than_one_hour_ago?(user_id)
    DateTime.parse(REDIS.hget(brainstorm_key, user_id)) < Time.now-1.hour
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def brainstorm_timer_running_key
    "brainstorm_id_timer_running_#{@brainstorm.token}"
  end

  def user_key
    "#{@session_id}"
  end

  def done_voting_brainstorm_status
    "done_voting_brainstorm_status_#{@brainstorm.token}"
  end

  def generate_random_temporary_user_name
    "Anonymous Brainstormer"
  end
end
