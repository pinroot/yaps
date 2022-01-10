require 'socket'
require 'timeout'

module ActivePinger
  class TCP
    def initialize(address, port, conn_timeout)
      @address = address
      @port = port
      @conn_timeout = conn_timeout
    end

    def check(ip, port, timeout)
      checked_at = Time.now
      begin
        Timeout::timeout(timeout) do
          begin
            socket = TCPSocket.new(ip, port, connect_timeout: timeout)
            return {status: true, exception: nil, checked_at: checked_at }
          rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, SocketError => e
            return {status: false, exception: e.to_s, checked_at: checked_at}
          end
        end
      rescue Timeout::Error => e
        return {status: false, exception: e.to_s, checked_at: checked_at}
      end
    end

    def up?
      check(@address, @port, @conn_timeout)[:status]
    end

    def down?
      !check(@address, @port, @conn_timeout)[:status]
    end

    def exception
      check(@address, @port, @conn_timeout)[:exception]
    end

    def time_diff_milli(start, finish)
      (finish - start) * 1000.0
    end

    def duration
      time_diff_milli(check(@address, @port, @conn_timeout)[:checked_at], Time.now)
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
