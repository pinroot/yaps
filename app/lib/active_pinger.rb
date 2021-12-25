module ActivePinger
  class TCP
    def initialize(address, port, conn_timeout)
      @address = address
      @port = port
      @conn_timeout = conn_timeout
      @connection = Net::Ping::TCP.new(@address, @port, @conn_timeout)
    end
    def is_port_up?
      if @connection.ping
        true
      else
        false
      end
    end
    def time
      @connection.ping
    end
  end

end
