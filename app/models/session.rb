class Session
  attr_reader :visitor_id, :guest_id, :user_id, :name

  def initialize(visitor_id, guest_id=nil, user_id=nil)
    @visitor_id, @guest_id, @user_id = visitor_id, guest_id, user_id
    
    set_hash
  end

  def set_hash
    @key = Kredis.hash(visitor_id)
    @key.update(
      "visitor_id" => visitor_id.to_s, 
      "guest_id" => guest_id.to_s, 
      "user_id" => user_id.to_s, 
      "name" => set_name
    )  
  end

  def set_name
    if user_id
      @name = User.find(user_id).name
    elsif guest_id
      @name = Guest.find(guest_id).name
    else 
      @name = generate_or_retrieve_name(visitor_id)
    end
  end

  def generate_or_retrieve_name(visitor_id)
    stored_name = retrieve_name_from_storage(visitor_id)
    return stored_name if stored_name

    generated_name = generate_name
    @name = generated_name
    generated_name
  end

  def retrieve_name_from_storage(visitor_id)
     @key["name"]
  end

  def generate_name
    adjectives = ["Sleeping", "Hungry", "Purple", "Hairy", "Wet", "Hungarian", "Australian", "Cross-eyed", "Mind-reading", "Fierce", "Wig-wearing", "Busy", "Bingo-playing", "Talking", "Cool", "Amazing", "Happy", "Lovely", "Tomb Raiding", "Self-aware", "Flying", "Bald", "The Best", "Space-exploring", "To-the-point", "Forgetful", "Visionary", "Well-behaved", "Totally Awesome", "Hilarious", "Charming", "Royal", "Rapid", "Adorable", "Cheerful", "Expert", "Wacky", "Fluffy", "Smart", "Well-articulated", "Sophisticated", "Tickly", "Wise", "Lucky", "The One True", "Unreal", "Silly", "Smooth", "Tongue-twisting", "Tiny", "Carnivorous", "Vegetarian", "Grounded", "Mischievous", "Tropical", "Arctic", "Polite", "Frivolous", "Tactical", "Organized", "Dazzled", "Jolly", "Diligent", "Famous", "Hip", "Bored", "Unmarried", "Travelling", "Brainy", "Blue-eyed", "Nosey", "Adventurous", "Acidic", "Important"]
    nouns = ["Tiger", "Turtle", "Cat", "Sloth", "Hedgehog", "Space Explorer", "Mouse", "Hamster", "Tea Pot", "Alien", "Traveller", "Bear", "Fish", "Donkey", "Horse", "Zebra", "Lion", "Otter", "Spider", "Architect", "Surgeon", "Friend", "Coffee Cup", "Computer", "Super Hero", "Boy", "Girl", "Ant", "Dinosaur", "Bird", "Camel", "Duck", "Gecko", "Astronaut", "Biologist", "Villain", "Body Builder", "Gummy Bear", "Ice Cream", "Ferret", "Fox", "Alpaca", "Wallaby", "Squid", "Beatle", "Beet", "Dog", "Snail", "Crab", "Camel", "Student", "Farmer", "Sheep", "Grandma", "Piggy", "Tarantula", "Hawk", "Crocodile", "Guitarist", "Drummer", "Organist", "Priest", "Hyena", "Marshmellow", "Rock", "Therapist", "Musician", "Penguin", "Piranha", "Duckling", "Puppy", "Toaster", "Barista", "Nephew", "Hippo", "Hipster", "Panda", "Bridesmaid", "Bat", "Suitcase", "Radiator", "Flashlight", "Escalator", "Elevator"]
  
    "#{adjectives.sample} #{nouns.sample}"
  end

  def id
    @key["visitor_id"]
  end

  def guest?
    !@key["guest_id"]&.empty?
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
