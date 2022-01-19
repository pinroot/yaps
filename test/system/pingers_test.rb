require "application_system_test_case"

class PingersTest < ApplicationSystemTestCase
  setup do
    @pinger = pingers(:one)
  end

  test "visiting the index" do
    visit pingers_url
    assert_selector "h1", text: "Pingers"
  end

  test "should create pinger" do
    visit pingers_url
    click_on "New pinger"

    fill_in "Address", with: @pinger.address
    check "Enabled" if @pinger.enabled
    fill_in "Interval", with: @pinger.interval
    fill_in "Name", with: @pinger.name
    fill_in "Pinger type", with: @pinger.pinger_type
    fill_in "Port", with: @pinger.port
    fill_in "Timeout", with: @pinger.timeout
    click_on "Create Pinger"

    assert_text "Pinger was successfully created"
    click_on "Back"
  end

  test "should update Pinger" do
    visit pinger_url(@pinger)
    click_on "Edit this pinger", match: :first

    fill_in "Address", with: @pinger.address
    check "Enabled" if @pinger.enabled
    fill_in "Interval", with: @pinger.interval
    fill_in "Name", with: @pinger.name
    fill_in "Pinger type", with: @pinger.pinger_type
    fill_in "Port", with: @pinger.port
    fill_in "Timeout", with: @pinger.timeout
    click_on "Update Pinger"

    assert_text "Pinger was successfully updated"
    click_on "Back"
  end

  test "should destroy Pinger" do
    visit pinger_url(@pinger)
    click_on "Destroy this pinger", match: :first

    assert_text "Pinger was successfully destroyed"
  end
end
