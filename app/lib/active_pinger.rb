require 'socket'
require 'timeout'
require 'resolv'

module ActivePinger
  class TCP  
    RESOLVER_NAMESERVERS = ['8.8.8.8', '8.8.4.4']
    RESOLVER_TIMEOUT = 0.2
    RESOLVER = Resolv::DNS.new(nameserver: RESOLVER_NAMESERVERS)

    def initialize(host, port, conn_timeout)
      @host         = host
      @port         = port
      @conn_timeout = conn_timeout
    end

    def get_ipaddress(fqdn, conn_timeout)
      RESOLVER.timeouts=conn_timeout
      RESOLVER.getaddress(fqdn).to_s
    end

    def check_port(host, port, conn_timeout)
      checked_at = Time.now
      begin
        resolved_host = get_ipaddress(host, RESOLVER_TIMEOUT)
        socket      = Socket.new(:INET, :STREAM)
        remote_addr = Socket.sockaddr_in(port, resolved_host)
 
        begin
          socket.connect_nonblock(remote_addr)
        rescue Errno::EINPROGRESS
        end

        _, sockets, _ = IO.select(nil, [socket], nil, conn_timeout)
 
        if sockets
          return { status: true, exception: nil, checked_at: checked_at }
        else
          return { status: false, exception: "Connection Refused", checked_at: checked_at }
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

    def duration
      time_diff_milli(check[:checked_at], Time.now)
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
