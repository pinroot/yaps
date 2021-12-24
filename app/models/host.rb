class Host < ApplicationRecord
  validates_presence_of :name, :fqdn
end
