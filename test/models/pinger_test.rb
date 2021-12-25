require "test_helper"

class PingerTest < ActiveSupport::TestCase

  test "Pinger attributes must not be empty" do
    pinger = Pinger.new
    assert pinger.invalid?
    assert pinger.errors[:name].any?
    assert pinger.errors[:ping_type].any?
    assert pinger.errors[:address].any?
    assert pinger.errors[:interval].any?
    assert pinger.errors[:timeout].any?
  end

  def new_pinger(address)
    Pinger.new( name: "SOMEPINGER",
    ping_type: 1,
    address: address,
    interval: 300,
    timeout: 1)
  end

  test "address must be a fqdn" do
    good = %w{ yandex.ru google.com foo.bar.baz }
    bad = %w{ foo bar baz hello _world }


    good.each do |address|
      assert new_pinger(address).valid?,
      "#{address} shouldn't be invalid"
    end

    bad.each do |address|
      assert new_pinger(address).invalid?,
      "#{address} shouldn't be valid"
    end
  end

end
