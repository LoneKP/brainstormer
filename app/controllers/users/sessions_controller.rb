# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  
  # GET /resource/sign_in
  def new
    @quote = generate_quote
    super
  end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def generate_quote
    options = 
      [["The value of an idea lies in the using of it."],["Thomas Edison (1847 – 1931), Inventor"]],
      [["If at first the idea is not absurd, then there is no hope for it."],["Albert Einstein (1879 – 1955), Mathematician"]],
      [["What good is an idea if it remains an idea? Try. Experiment. Fail. Try again. Change the world."],["Simon Sinek (born 1973), Author, motivational-consultant"]],
      [["Ideas are like rabbits. You get a couple and learn how to handle them, and pretty soon you have a dozen."],["John Steinbeck (1902 – 1968), Nobel awarded author"]],
      [["The way to get good ideas is to get lots of ideas and throw the bad ones away."],["Linus Pauling (1901 – 1994), Chemist, author, and educator"]],
      [["All sorts of things can happen when you’re open to new ideas and playing around with things."],["Stephanie Kwolek (1923-2014), Chemist"]],
      [["If it’s a good idea, go ahead and do it. It is often easier to ask for forgiveness than to ask for permission."],["Grace Hopper (1906-1992), Computer scientist and Navy admiral"]],
      [["Be less curious about people and more curious about ideas."],["Marie Curie (1867-1934), Polish-French physicist and first female Nobel Prize winner"]]
    options.sample
  end
end
