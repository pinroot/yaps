class Pinger < ApplicationRecord
  enum pinger_type: [ :simple_tcp_port_check ]

  has_many :pinger_events, dependent: :destroy

  validates_presence_of :name, :ping_type, :address, :interval, :timeout

  validates :address, format: {
    with:    %r{[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$}i, multiline: true,
    message: 'must be a FQDN'
  }

end
