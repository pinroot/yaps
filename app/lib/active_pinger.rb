module ActivePinger
  class TCP
    def initialize(address, port, conn_timeout)
      @address = address
      @port = port
      @conn_timeout = conn_timeout
      @connection = Net::Ping::TCP.new(@address, @port, @conn_timeout)
    end
    def up?
      if @connection.ping and @connection.exception.nil?
        true
      else
        false
      end
    end
    def down?
      if @connection.ping and @connection.exception.nil?
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
        Rails.logger.info "INSPECT FROM NIL: #{@connection.inspect}"
      else
        return "unknown"
        Rails.logger.info "INSPECT FROM UNKNOWN: #{@connection.inspect}"
      end
    end
  end

end
