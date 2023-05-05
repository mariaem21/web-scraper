class ContactOrganization < ApplicationRecord
    has_many :applications, dependent: :destroy
end
