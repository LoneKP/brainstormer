class CheckFreeTrialCriteriaJob
  include Sidekiq::Job

  def perform
    User.find_each do |user|
      if meets_criteria?(user)
        puts "#{user.name} meets criteria"
        Mailer::SendFreeTrialJob.perform_later(user.id)
      end
    end
  end

  private

  def meets_criteria?(user)
    over_a_month_after_signup?(user) &&
    has_created_two_or_more_brainstorms_in_the_recent_30_days?(user) &&
    !user.facilitator_plan?
  end
  

  def over_a_month_after_signup?(user)
    Time.now > user.created_at + 1.month
  end 

  def has_created_two_or_more_brainstorms_in_the_recent_30_days?(user)
    brainstorms_created_the_last_30_days(user) >= 2
  end

  def brainstorms_created_the_last_30_days(user)
    user.brainstorms.count do |brainstorm| 
      Time.now - brainstorm.created_at <= 30.days
    end
  end
end
