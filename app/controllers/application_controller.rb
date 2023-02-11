class ApplicationController < ActionController::Base
  include PlanLimits

  before_action :set_visitor_id
  before_action :set_return_path

  def set_return_path
    return if devise_controller? || !request.method === "GET"

    session["user_return_to"] = request.url unless current_user
  end
  
  private

  def set_current_facilitator
    if @brainstorm.facilitated_by_type === "Guest"
      Current.facilitator = Guest.find_by(id: @session.guest_id) if @brainstorm.facilitated_by === Guest.find_by(id: @session.guest_id)
    elsif @brainstorm.facilitated_by_type === "User"
      Current.facilitator = User.find_by(id: @session.user_id) if @brainstorm.facilitated_by === User.find_by(id: @session.user_id)
    end
  end

  def set_session_for_all_types
    set_visitor_id
    set_current_guest
    set_name
    @session = Session.new(@visitor_id, @current_guest&.id, current_user&.id, @name)
  end

  def set_visitor_id
    @visitor_id = cookies[:visitor_id] ||= SecureRandom.uuid
  end

  def set_current_guest
    if !current_user
      @current_guest ||= Guest.find(session[:guest_id]) if session[:guest_id]
    end
  end

  def set_name
    @name ||= current_user&.name.presence || @current_guest&.name.presence || set_random_name
  end

  def set_random_name
    adjectives = ["Sleeping", "Hungry", "Purple", "Hairy", "Wet", "Hungarian", "Australian", "Cross-eyed", "Mind-reading", "Fierce", "Wig-wearing", "Busy", "Bingo-playing", "Talking", "Cool", "Amazing", "Happy", "Lovely", "Tomb Raiding", "Self-aware", "Flying", "Bald", "The Best", "Space-exploring", "To-the-point", "Forgetful", "Visionary", "Well-behaved", "Totally Awesome", "Hilarious", "Charming", "Royal", "Rapid", "Adorable", "Cheerful", "Expert", "Wacky", "Fluffy", "Smart", "Well-articulated", "Sophisticated", "Tickly", "Wise", "Lucky", "The One True", "Unreal", "Silly", "Smooth", "Tongue-twisting", "Tiny", "Carnivorous", "Vegetarian", "Grounded", "Mischievous", "Tropical", "Arctic", "Polite", "Frivolous", "Tactical", "Organized", "Dazzled", "Jolly", "Diligent", "Famous", "Hip", "Bored", "Unmarried", "Travelling", "Brainy", "Blue-eyed", "Nosey", "Adventurous", "Acidic", "Important"]
    nouns = ["Tiger", "Turtle", "Cat", "Sloth", "Hedgehog", "Space Explorer", "Mouse", "Hamster", "Tea Pot", "Alien", "Traveller", "Bear", "Fish", "Donkey", "Horse", "Zebra", "Lion", "Otter", "Spider", "Architect", "Surgeon", "Friend", "Coffee Cup", "Computer", "Super Hero", "Boy", "Girl", "Ant", "Dinosaur", "Bird", "Camel", "Duck", "Gecko", "Astronaut", "Biologist", "Villain", "Body Builder", "Gummy Bear", "Ice Cream", "Ferret", "Fox", "Alpaca", "Wallaby", "Squid", "Beatle", "Beet", "Dog", "Snail", "Crab", "Camel", "Student", "Farmer", "Sheep", "Grandma", "Piggy", "Tarantula", "Hawk", "Crocodile", "Guitarist", "Drummer", "Organist", "Priest", "Hyena", "Marshmellow", "Rock", "Therapist", "Musician", "Penguin", "Piranha", "Duckling", "Puppy", "Toaster", "Barista", "Nephew", "Hippo", "Hipster", "Panda", "Bridesmaid", "Bat", "Suitcase", "Radiator", "Flashlight", "Escalator", "Elevator"]

    "#{adjectives.sample} #{nouns.sample}"
  end

  def set_portal_session
    return if current_user.payment_processor.nil?
    @portal_session = current_user.payment_processor.billing_portal
  end

  def set_access
    unless @brainstorm.nil?
      @access_to_brainstorms_duration = plan_data(:access_to_brainstorm_duration, @brainstorm.facilitated_by.plan)
      @access_to_pdf_export = plan_data(:access_to_pdf_export, @brainstorm.facilitated_by.plan)
    end
    unless current_user.nil?
      @access_to_your_brainstorms = plan_data(:access_to_your_brainstorms, current_user.plan)
    end
  end
end
