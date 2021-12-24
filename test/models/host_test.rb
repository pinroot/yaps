require "test_helper"

class HostTest < ActiveSupport::TestCase

  test "Host attributes must not be empty" do
    host = Host.new
    assert host.invalid?
    assert host.errors[:name].any?
    assert host.errors[:fqdn].any?
  end

  def new_host(fqdn)
    Host.new( name: "SOMEHOST",
    fqdn: fqdn)
  end

  test "fqdn must be a fqdn" do
    good = %w{ yandex.ru google.com foo.bar.baz }
    bad = %w{ foo bar baz hello _world }

    good.each do |fqdn|
      assert new_host(fqdn).valid?,
      "#{fqdn} shouldn't be invalid"
    end

    bad.each do |fqdn|
      assert new_host(fqdn).invalid?,
      "#{fqdn } shouldn't be valid"
    end
  end

end
