class BrainstormChannel < ApplicationCable::Channel
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
    REDIS.sadd brainstorm_key, session_id
    transmit_list!
  end

  def remove_from_list_and_transmit!
    REDIS.srem brainstorm_key, session_id
    transmit_list!
  end

  def set_guest_name_if_user_has_no_name
    if REDIS.get(session_id).nil?
      REDIS.sadd "no_user_name", session_id
      REDIS.set session_id, "GUEST"
    end
  end

  def transmit_list!
    users = REDIS.smembers(brainstorm_key)

    names = []
    initials = []
    user_ids = []
    users.each do |user_id|
      name = REDIS.get(user_id)
      names << name
      user_ids << user_id
      initials << name.split(nil,2).map(&:first).join.upcase
    end

    data = {
      event: "transmit_list",
      users: names,
      initials: initials,
      user_ids: user_ids,
      no_user_names: REDIS.smembers("no_user_name")
    }

    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}", data)
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end
end
