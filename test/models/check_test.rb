require "test_helper"

class CheckTest < ActiveSupport::TestCase
  
  test "Check attributes must not be empty" do
    check = Check.new
    assert check.invalid?
    assert check.errors[:type].any?
    assert check.errors[:interval].any?
    assert check.errors[:timeout].any?
  end
    
end
