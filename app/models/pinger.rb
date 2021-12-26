class Pinger < ApplicationRecord

  after_create :create_pinger_job
  after_update :update_pinger_job
  after_destroy :destroy_pinger_job

  enum pinger_type: [ :simple_tcp_port_check ]

  has_many :pinger_events, dependent: :destroy
  has_many :events, foreign_key: "pinger_id", class_name: "PingerEvent", dependent: :destroy

  validates_presence_of :name, :address, :interval, :timeout, :pinger_type

  validates :address, format: {
    with:    %r{[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$}i, multiline: true,
    message: 'must be a FQDN'
  }

  def create_pinger_job
    SimpleTcpPortCheckJob.perform_async(id) if pinger_type == "simple_tcp_port_check"
  end

  def update_pinger_job
  end

  def destroy_pinger_job
  end

end
