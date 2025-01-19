# test/controllers/static_pages_controller_test.rb
require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_url
    assert_response :success
  end
end
