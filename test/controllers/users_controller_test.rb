require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_path
    assert_response :success
    assert_select "form[action=?][method=?]", users_path, "post"
  end
end
