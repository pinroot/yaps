class SimpleTcpPortCheckJob
  include SuckerPunch::Job

  def perform(pinger_id)

    @pinger = Pinger.find(pinger_id)
    
    @check = ActivePinger::TCP.new(@pinger.address, @pinger.port, @pinger.timeout)    

    def build_event
      if @check.down?
        event = @pinger.events.build(status: "down", reason: @check.exception)
      elsif @check.up?
        event = @pinger.events.build(status: "up", reason: "Connection allowed")
      else
        event = @pinger.events.build(status: "unknown", reason: "UNKNOWN")
        # LOG
        Rails.logger.info "INSPECT: #{@check.inspect}"
      end
      event.save
    end

    def update_pinged_at
      @pinger.update_columns(pinged_at: Time.now)
    end

    build_event if @check.status != @pinger.events.last.status
    update_pinged_at

  end

end
