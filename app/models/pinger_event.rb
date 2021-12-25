class PingerEvent < ApplicationRecord
  belongs_to :pinger
  validates_presence_of :pinger_id, :reason, :status

end
