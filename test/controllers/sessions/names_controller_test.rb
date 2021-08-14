require "test_helper"

class Sessions::NamesControllerTest < ActionDispatch::IntegrationTest
  test "update" do
    patch session_name_url(token: "xyz", format: :js), params: { session: { name: "Lone" } }
    assert_response :success
  end
end
