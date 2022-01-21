require "test_helper"

class PingersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pinger = pingers(:one)
  end

  test "should get index" do
    get pingers_url
    assert_response :success
  end

  test "should get new" do
    get new_pinger_url
    assert_response :success
  end

  test "should create pinger" do
    assert_difference("Pinger.count") do
      post pingers_url, params: { pinger: { address: @pinger.address, enabled: @pinger.enabled, interval: @pinger.interval, name: @pinger.name, pinger_type: @pinger.pinger_type, port: @pinger.port, timeout: @pinger.timeout } }
    end

    assert_redirected_to pinger_url(Pinger.last)
  end

  test "should show pinger" do
    get pinger_url(@pinger)
    assert_response :success
  end

  test "should get edit" do
    get edit_pinger_url(@pinger)
    assert_response :success
  end

  test "should update pinger" do
    patch pinger_url(@pinger), params: { pinger: { address: @pinger.address, enabled: @pinger.enabled, interval: @pinger.interval, name: @pinger.name, pinger_type: @pinger.pinger_type, port: @pinger.port, timeout: @pinger.timeout } }
    assert_redirected_to pinger_url(@pinger)
  end

  test "should destroy pinger" do
    assert_difference("Pinger.count", -1) do
      delete pinger_url(@pinger)
    end

    assert_redirected_to pingers_url
  end
end
