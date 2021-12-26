class SimpleTcpPortCheckJob
  include SuckerPunch::Job

  def perform(pinger_id)

    @pinger = Pinger.find(pinger_id)
    
    @check = ActivePinger::TCP.new(@pinger.address, @pinger.port, @pinger.timeout)    

    def get_current_status
      if @check.up?
        status = "up"
      else
        status ="down"
      end
      return status
    end

    def get_previous_status
      if @pinger.events.any?
        status = @pinger.events.last.status
      else
        status = "unknown"
      end
      return status
    end

    def build_event
      if get_current_status == "down" and get_previous_status != get_current_status
        event = @pinger.events.build(reason: @check.exception, status: get_current_status)
      elsif get_current_status == "up" and get_previous_status != get_current_status
        event = @pinger.events.build(reason: "Connection established", status: get_current_status)
      end
      event.save if event
    end    

    build_event

    Rails.logger.info "Previous status #{get_previous_status}"
    Rails.logger.info "Current status #{get_current_status}"

  end

end
