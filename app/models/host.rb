class Host < ApplicationRecord
  validates_presence_of :name, :fqdn

  validates :fqdn, format: {
    with:    %r{[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$}i, multiline: true,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }

end
