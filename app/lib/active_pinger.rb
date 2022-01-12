require 'timeout'
require 'async/io'
require 'async/await'
require 'async/semaphore'
require 'resolv'

module ActivePinger
  class TCP  
    include Async::Await
    include Async::IO
    RESOLVER = Resolv::DNS.new
    RESOLVER_TIMEOUT = 0.2

    def initialize(host, port, conn_timeout)
      @host         = host
      @port         = port
      @conn_timeout = conn_timeout
      @semaphore    = Async::Semaphore.new(1024)
    end

    def get_ipaddress(fqdn, conn_timeout)
      RESOLVER.timeouts=conn_timeout
      RESOLVER.getaddress(fqdn).to_s
    end

    def check_port(host, port, conn_timeout)
      checked_at   = Time.now
      begin
        resolved_host = get_ipaddress(host, RESOLVER_TIMEOUT)
        begin
          Timeout.timeout(conn_timeout) do
            Async::IO::Endpoint.tcp(resolved_host, port).connect do |peer|
              peer.close
              return { status: true, exception: nil, checked_at: checked_at }
            end
          end
        rescue Errno::ECONNREFUSED, Async::TimeoutError, SocketError, Timeout::Error => e
          return {status: false, exception: e.to_s, checked_at: checked_at }
        rescue Errno::EMFILE
          sleep conn_timeout
          retry
        end
      rescue Resolv::ResolvError => e
        return {status: false, exception: e.to_s, checked_at: checked_at }
      end
    end

    async def check(host: @host, port: @port, timeout: @conn_timeout)
      @semaphore.async do
        check_port(host, port, timeout)
      end
    end

    def up?
      check.result.result[:status]
    end

    def down?
      !check.result.result[:status]
    end

    def exception
      check.result.result[:exception]
    end

    def time_diff_milli(start, finish)
      (finish - start) * 1000.0
    end

    def duration
      time_diff_milli(check.result.result[:checked_at], Time.now)
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
