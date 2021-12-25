require "test_helper"

class PingerEventTest < ActiveSupport::TestCase

  test "PingerEvent attributes must not be empty" do
    pinger_event = PingerEvent.new
    assert pinger_event.invalid?
    assert pinger_event.errors[:pinger_id].any?
    assert pinger_event.errors[:reason].any?
    assert pinger_event.errors[:status].any?
  end

end
