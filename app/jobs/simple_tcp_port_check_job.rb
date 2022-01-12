class SimpleTcpPortCheckJob
  include SuckerPunch::Job
  def perform(pinger_id)
    @pinger = Pinger.find(pinger_id)

    @last_event = @pinger.events.last
    
    @checker = ActivePinger::TCP.new(@pinger.address, @pinger.port, @pinger.timeout)

    def set_reason
      if @checker.up?
        return "Connection allowed"
      elsif @checker.down?
        return @checker.exception
      else
        return "Unknown"
      end
    end
    if @checker.status != @last_event.status
      @pinger.events.build(status: @checker.status, reason: set_reason).save 
    end
    @pinger.update_columns(pinged_at: Time.now)
  end
end
