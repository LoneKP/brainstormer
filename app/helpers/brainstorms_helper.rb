module BrainstormsHelper
  def number_of_lines(problem)
    if device == "tablet" || device == "mobile"
     (problem.size.to_f / 14.to_f).ceil
    else
     (problem.size.to_f / 24.to_f).ceil
    end
  end
end