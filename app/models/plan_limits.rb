module PlanLimits
  def plan_data(use_case, tier)
    h = {
      :participant_limit => {
        1 => 10,
        2 => 25
      },
      :plan_name => {
        1 => "hobbyist",
        2 => "facilitator",
        3 => "organization"
      }
    }
    h[use_case][tier]
  end
end