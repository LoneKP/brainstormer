class BrainstormChannel < ApplicationCable::Channel
  def subscribed
    @user = session_id
    unless user_has_no_name?
      @brainstorm = Brainstorm.find(params[:id])
      stream_from "brainstorm-#{@brainstorm.id}"
      add_to_list_and_transmit!
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
    REDIS.sadd brainstorm_key, user_key unless already_present?
    transmit_list!
  end

  def remove_from_list_and_transmit!
    REDIS.srem brainstorm_key, user_key
    transmit_list!
  end

  def user_has_no_name?
    REDIS.get(user_key).nil?
  end

  def already_present?
    REDIS.sscan(brainstorm_key, 0, match: user_key).last.any?
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
      users: names,
      initials: initials,
      user_ids: user_ids,
    }

    ActionCable.server.broadcast("brainstorm-#{@brainstorm.id}", data)
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.id}"
  end

  def user_key
    @user
  end
end
