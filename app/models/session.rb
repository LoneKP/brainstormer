class Session
  attr_reader :visitor_id, :guest_id, :user_id, :name

  def initialize(visitor_id, guest_id=nil, user_id=nil, name)
    @visitor_id, @guest_id, @user_id, @name = visitor_id, guest_id, user_id, name
    set_hash
  end

  def set_hash
    @key = Kredis.hash(visitor_id)
    @key.update(
      "visitor_id" => visitor_id.to_s, 
      "guest_id" => guest_id.to_s, 
      "user_id" => user_id.to_s, 
      "name" => name.to_s
    )  
  end

  def id
    @key["visitor_id"]
  end

  def guest?
    !@key["guest_id"].empty?
  end

  def user?
    !@key["user_id"].empty?
  end

  def guest
    @key["guest_id"]
  end

  def user
    @key["user_id"]
  end

  def type
    if guest?
      "guest"
    elsif user?
      "user"
    else
      "visitor"
    end
  end
end
