class Pinger < ApplicationRecord

  after_create :create_pinger_scheduler
  after_update :update_pinger_scheduler
  after_destroy :destroy_pinger_scheduler

  enum pinger_type: [ :simple_tcp_port_check ]

  has_many :pinger_events, dependent: :destroy
  has_many :events, foreign_key: "pinger_id", class_name: "PingerEvent", dependent: :destroy

  validates_presence_of :name, :address, :interval, :timeout, :pinger_type

  validates :address, format: {
    with:    %r{[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$}i, multiline: true,
    message: 'must be a FQDN'
  }

  def create_pinger_scheduler
    scheduler = Rufus::Scheduler.singleton.every "#{interval}s", job: true do
      SimpleTcpPortCheckJob.perform_async(id) if pinger_type == "simple_tcp_port_check"
    end
    update_columns(scheduler_job_id: scheduler.job_id)
  end

  def update_pinger_scheduler
  end

  def destroy_pinger_scheduler
    scheduler = Rufus::Scheduler.singleton.job(scheduler_job_id) if scheduler_job_id.presence
    scheduler.unschedule if scheduler
  end

end
