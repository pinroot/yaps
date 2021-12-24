require "test_helper"

class HostTest < ActiveSupport::TestCase

  test "Host attributes must not be empty" do
    host = Host.new
    assert host.invalid?
    assert host.errors[:name].any?
    assert host.errors[:fqdn].any?
  end

end
