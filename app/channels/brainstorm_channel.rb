class BrainstormChannel < ApplicationCable::Channel
  def subscribed
    @user = session_id
    @brainstorm = Brainstorm.find(params[:id])
    stream_from "brainstorm-#{@brainstorm.id}"
    add_to_list_and_transmit!
  end

  def unsubscribed
    remove_from_list_and_transmit!
  end

  private

  def add_to_list_and_transmit!
    add_name_to_users_without_name
    REDIS.sadd brainstorm_key, user_key unless already_present?
    transmit_list!
  end

  def remove_from_list_and_transmit!
    REDIS.srem brainstorm_key, user_key
    transmit_list!
  end

  def already_present?
    REDIS.sscan(brainstorm_key, 0, match: user_key).last.any?
  end

  def transmit_list!
    users = REDIS.smembers(brainstorm_key)

    names = []
    users.each do |user|
      name = REDIS.get(user)
      names << name
    end

    data = {
      users: names,
    }

    ActionCable.server.broadcast("brainstorm-#{@brainstorm.id}", data)
  end

  def generate_user_name
    "#{random_adjective} #{random_animal}"
  end

  def add_name_to_users_without_name
    if REDIS.get(user_key).nil?
      REDIS.set user_key, generate_user_name
    end
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.id}"
  end

  def user_key
    @user
  end

  def random_adjective
    adjectives = ["Wild", "Tame", "White", "Black", "Striped", "Invisible", "Blue", "Flourescent", "Tall", "Creative", "Boring", "Ethereal-sounding", "Colorful", "Van Gogh's", "Cool", "Famous", "Flying"]

    number_of_adjectives = adjectives.count

    adjectives[rand(0..number_of_adjectives-1)]
  end

  def random_animal
   animals = ["leopard", "mouse", "falcon", "seabass", "sparrow", "lion", "turtle", "beetle", "bee", "fly", "bear", "worm", "zebra", "wilderbeest", "hawk", "eagle", "impala", "cat", "tiger", "puppy"]

   number_of_animals = animals.count

   animals[rand(0..number_of_animals-1)]
  end
end
