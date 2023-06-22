class CheckFreeTrialCriteriaJob
  include Sidekiq::Job
  require 'sidekiq-scheduler'


  #send out the free trial email if:

  # it is over a month after the user has signed up
  # the user has created 2 brainstorms over the last month
  # the user is not on facilitator plan
  # the user hasn't received this email before and has not opted out (this is checked for in Mailer::SendFreeTrialJob)

  def perform
    users = User.where("users.created_at <= ?", 1.month.ago)
                .where("users.id IN (
                  SELECT facilitated_by_id FROM brainstorms
                  WHERE facilitated_by_type = 'User'
                    AND brainstorms.created_at >= ?)", 30.days.ago.beginning_of_day)
                .joins(:brainstorms)
                .group('users.id')
                .having('COUNT(brainstorms.id) >= 2')
  
    users.find_each do |user|
      if !user.facilitator_plan?
        puts "#{user.name} meets criteria"
        Mailer::SendFreeTrialJob.perform_later(user.id)
      end
    end
  end

end
