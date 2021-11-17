require "test_helper"

class BrainstormsControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    @brainstorm = Brainstorm.create! name: "Lone", problem: "Too few good ideas"

    get brainstorm_show_path(@brainstorm.token)
    assert_response :success
  end
end
