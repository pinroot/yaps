class SimpleTcpPortCheckJob
  include SuckerPunch::Job

  def perform(pinger_id)

    pinger = Pinger.find(pinger_id)

    check = ActivePinger::TCP.new(pinger.address, pinger.port, pinger.timeout)

    event = pinger.events.build

    if check.up?
      event.reason="nil"
      event.status="up"
    else
      event.reason=check.exception
      event.status="down"
    end
    
    event.save

    #if pinger.events.empty?
    #  event.save
    #else
    #  event.save if pinger.events.last.status != event.status
    #end
  end

end
