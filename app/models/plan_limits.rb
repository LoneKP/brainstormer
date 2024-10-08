module PlanLimits
  def plan_data(use_case, plan)
    h = {
      :participant_limit => {
        1 => 10,
        2 => 25
      },
      :plan_name => {
        1 => "hobbyist",
        2 => "facilitator",
        3 => "organization"
      },
      :access_to_your_brainstorms => {
        1 => false,
        2 => true,
        3 => true
      },
      :access_to_brainstorm_duration => {
        1 => false,
        2 => true,
        3 => true
      },
      :access_to_export_features => {
        1 => false,
        2 => true,
        3 => true
      }
    }
    h[use_case][plan]
  end
end