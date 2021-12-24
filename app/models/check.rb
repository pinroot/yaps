class Check < ApplicationRecord
  belongs_to :host
  validates_presence_of :type, :interval, :timeout
end
