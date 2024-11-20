class PresenceChannel < ApplicationCable::Channel

  include PlanLimits

  def subscribed
    if @brainstorm = Brainstorm.find_by(token: params[:token])
      stream_or_reject_for @brainstorm
      add_to_list_and_transmit!
      @brainstorm.update(max_participants: online_participant_count) if online_participant_count > @brainstorm.max_participants
    end
  end

  def unsubscribed
    remove_from_list_and_transmit!
  end

  def update_name
    transmit_list!
  end

  private

  def add_to_list_and_transmit!
    REDIS_SESSION.set user_color_key, random_color_class
    if params[:waiting_room] === false
      REDIS_SESSION.hset brainstorm_key, visitor_id, Time.now.to_s
    elsif params[:waiting_room] === true
      REDIS_SESSION.hset in_brainstorm_waiting_room, visitor_id, params[:waiting_room]
    end
    transmit_list!
  end

  def remove_from_list_and_transmit!
    REDIS_SESSION.hdel brainstorm_key, visitor_id
    REDIS_SESSION.hdel in_brainstorm_waiting_room, visitor_id
    transmit_list!
  end

  def transmit_list!
    visitors = REDIS_SESSION.hgetall(brainstorm_key).keys
    data = { 
      event: "transmit_presence_list",
      online_users: {},
      number_of_users_in_waiting_room: REDIS_SESSION.hgetall(in_brainstorm_waiting_room).keys.count,
      max_allowed_participants: plan_data(:participant_limit, @brainstorm.facilitated_by.plan)
    }
    
    visitors.each do |visitor|
      unless last_user_activity_more_than_one_hour_ago?(visitor)
        name = REDIS_SESSION.hgetall(visitor)["name"]
        user_color = REDIS_SESSION.get("user_color_for_user_id_#{visitor}")
        done_voting = REDIS_SESSION.hget(done_voting_brainstorm_status, "#{visitor}")
        data[:online_users][visitor] = {
          id: visitor, 
          name: name, 
          initials: "HI",
          #initials: name.split(nil,2).map(&:first).join.upcase, 
          userColor: user_color, 
          doneVoting: done_voting
        }
      end
    end
    
    PresenceChannel.broadcast_to @brainstorm, data
  end

  def last_user_activity_more_than_one_hour_ago?(user_id)
    DateTime.parse(REDIS_SESSION.hget(brainstorm_key, user_id)) < Time.now-1.hour
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def online_participant_count
    REDIS_SESSION.hgetall(brainstorm_key).keys.count
  end

  def user_key
    "#{visitor_id}"
  end

  def user_color_key
    "user_color_for_user_id_#{visitor_id}"
  end

  def done_voting_brainstorm_status
    "done_voting_brainstorm_status_#{@brainstorm.token}"
  end

  def in_brainstorm_waiting_room
    "in_brainstorm_waiting_room_#{@brainstorm.token}"
  end

  def random_color_class
    color_classes = ["bg-purply", "bg-greeny", "bg-yellowy", "bg-reddy"]

    color_classes.sample
  end
end
