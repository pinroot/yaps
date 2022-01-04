module ActivePinger
  class TCP
    def initialize(address, port, conn_timeout)
      @address = address
      @port = port
      @conn_timeout = conn_timeout
      @connection = Net::Ping::TCP.new(@address, @port, @conn_timeout)
    end
    def up?
      if @connection.ping
        true
      else
        false
      end
    end
    def down?
      if @connection.ping
        false
      else
        true
      end
    end
    def duration
      @connection.duration
    end
    def exception
      @connection.exception
    end
    def status
      if up?
        return "up"
      elsif down?
        return "down"
      elsif @connection.ping == nil
        return "down"
        Rails.logger.info "INSPECT: #{@connection.inspect}"
      else
        return "unknown"
        Rails.logger.info "INSPECT: #{@connection.inspect}"
      end
    end
  end

end
