class BrainstormsController < ApplicationController
  include BrainstormScoped

  before_action :set_session, only: [:show, :create, :done_voting]

  def new
    @brainstorm = Brainstorm.new
  end

  def create
    @brainstorm = Brainstorm.new(brainstorm_params)

    respond_to do |format|
      if @brainstorm.save
        REDIS.set @session_id, @brainstorm.name
        @brainstorm.state = :setup
        @brainstorm.facilitator_session_id = @session_id

        format.js { render js: "window.location.href = '#{brainstorm_path(@brainstorm.token)}'" }
      else
        @brainstorm.errors.messages.each do |message|
          flash.now[message.first] = message[1].first
          format.js
        end
      end
    end
  end

  def show
    @ideas = @brainstorm.ideas
    @idea  = @ideas.new

    @current_facilitator = @brainstorm.facilitator.id == @session_id

    @voting = Session::Voting.new(@brainstorm, @session_id)
  end

  def go_to_brainstorm
    token = params[:token].remove("#")
    brainstorm = Brainstorm.find_sole_by_token(token)

    respond_to do |format|
      if !brainstorm.nil? && token.length >= 6
        format.js { render :js => "window.location.href = '#{brainstorm_path(brainstorm.token)}'" }
      elsif token.length == 0
        flash.now["token"] = "You forgot to write an ID! If you don't have one you should ask the facilitator"
        format.js
      elsif token.length < 6
        flash.now["token"] = "It looks like this ID is too short"
        format.js
      else
        flash.now["token"] = "It looks like this ID doesn't exist"
        format.js
      end
    end
  end

  def done_brainstorming
    start_voting
    @brainstorm.timer.reset
  end

  def start_brainstorm
    @brainstorm.state = :ideation
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: "ideation" })
    @brainstorm.timer.start
  end

  def start_voting
    @brainstorm.state = :vote
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: "vote" })
    transmit_ideas(sort_by_id_desc)
  end

  def done_voting
    @voting = Session::Voting.new(@brainstorm, @session_id)
    @voting.toggle_voting_done
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-presence", { event: "toggle_done_voting_badge", state: "vote", user_id: @session_id })
  end

  def end_voting
    @brainstorm.state = :voting_done
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-presence", { event: "remove_done_tags_on_user_badges" })
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-state", { event: "set_brainstorm_state", state: "voting_done" })
    transmit_ideas(sort_by_votes_desc)
  end

  def change_state
    @brainstorm.state = params[:new_state].to_sym
    ActionCable.server.broadcast("brainstorm-#{params[:token]}-state", { event: "set_brainstorm_state", state: params[:new_state] })
  end

  private

  def brainstorm_params
    params.require(:brainstorm).permit(:problem, :name)
  end

  def brainstorm_key
    "brainstorm_id_#{@brainstorm.token}"
  end

  def transmit_ideas(sorting_choice)
    ActionCable.server.broadcast("brainstorm-#{@brainstorm.token}-idea", { event: "transmit_ideas", ideas: ideas_and_idea_builds_object(sorting_choice) })
  end

  def ideas_and_idea_builds_object(sorting_choice)
    @brainstorm.ideas.order(sorting_choice).as_json(
      methods: [:vote_in_plural_or_singular, :number],
      only: [:id, :text, :votes],
      include: {
        idea_builds: {
          methods: [:vote_in_plural_or_singular, :decimal, :opacity_lookup],
          only: [:id, :idea_build_text, :votes]
        }
      })
  end

  def sort_by_id_desc
    'id DESC'
  end

  def sort_by_votes_desc
    'votes DESC'
  end
end
