# frozen_string_literal: true

class Application < ApplicationRecord
    validates :application_id, presence: true, uniqueness: true, comparison: { greater_than: -1 }
    validates :contact_organization_id, presence: true, comparison: { greater_than: -1 }
    validates :name, presence: true
    validates :date_built, presence: true
    validates :github_link, presence: true
    validates :description, presence: true

    # def organization_id_exists
    #     if !Organization.where(organization_id: self.organization_id).exists? then
    #         errors.add(:organization_id, 'Must have a valid organization ID.')
    #     end
    # end
end
