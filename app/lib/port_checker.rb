require 'socket'
require 'timeout'
require 'resolv'
require 'net/ping'

module PortChecker
  class TCPCheck
    RESOLVER_NAMESERVERS = ['8.8.8.8', '8.8.4.4']                # TODO: MUST GET FROM APP CONFIG
    RESOLVER_TIMEOUT = 0.2                                       # TODO: MUST GET FROM APP CONFIG
    RESOLVER = Resolv::DNS.new(nameserver: RESOLVER_NAMESERVERS)
    IPV4_REGEX_TEMPLATE = /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}/

    def initialize(host, port, conn_timeout)
      @host         = host
      @port         = port
      @conn_timeout = conn_timeout
    end

    def is_ip?(address)
      address.match? IPV4_REGEX_TEMPLATE
    end

    def get_ipaddress(fqdn, conn_timeout)
      RESOLVER.timeouts=conn_timeout
      RESOLVER.getaddress(fqdn).to_s
    end

    def check_port(host, port, conn_timeout)
      begin
        checked_at = Time.now
        host = get_ipaddress(host, RESOLVER_TIMEOUT) unless is_ip?(host)
        check = Net::Ping::TCP.new(host, port, conn_timeout)
        if check.ping?
          return { status: true, exception: nil, checked_at: checked_at, response_time: check.ping }
        else
          return { status: false, exception: check.exception, checked_at: checked_at, response_time: check.ping }
        end
      rescue Resolv::ResolvError => e
        return { status: false, exception: e.to_s, checked_at: checked_at }
      end
    end

    def check(host: @host, port: @port, timeout: @conn_timeout)
      check_port(host, port, timeout)
    end

    def up?
      check[:status]
    end

    def down?
      !check[:status]
    end

    def exception
      check[:exception]
    end

    def time_diff_milli(start, finish)
      (finish - start) * 1000.0
    end

    def response_time
      check[:response_time]
      #time_diff_milli(check[:checked_at], Time.now)
    end

    def status
      if up?
        return "up"
      elsif down?
        return "down"
      else
        return "unknown"
      end
    end

  end

end
