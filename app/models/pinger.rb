class Pinger < ApplicationRecord

  after_create :create_ping_job
  after_update :update_ping_job
  after_destroy :destroy_ping_job

  enum pinger_type: [ :simple_tcp_port_check ]

  has_many :pinger_events, dependent: :destroy
  has_many :events, foreign_key: "pinger_id", class_name: "PingerEvent", dependent: :destroy

  validates_presence_of :name, :address, :interval, :timeout, :pinger_type

  validates :address, format: {
    with:    %r{[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$}i, multiline: true,
    message: 'must be a FQDN'
  }

  def create_ping_job
    # let's try to create some ping
    # TCP Pinger example:
    # ActivePinger::TCP.new("google.com", 80, 1)

    if pinger_type == "simple_tcp_port_check"
      pinger = ActivePinger::TCP.new(address, port, timeout)
      event = events.build
      if pinger.is_port_up?
        event.reason="tcp port is up"
        event.status="up"
      else
        event.reason="tcp port is down"
        event.status="down"
      end
      event.save
    else
      # no pinger selected 
    end
  end

  def update_ping_job
  end

  def destroy_ping_job
  end

end
