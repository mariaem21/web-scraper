# frozen_string_literal: true

class Application < ApplicationRecord
    validates :application_id, presence: true, uniqueness: true
    validates :organization_id, presence: true
    validates :name, presence: true
    validates :date_built, presence: true
    validates :github_link, presence: true
    validates :description, presence: true
    
    # has_one :contact
    # validates :contact, presence: true
    # belongs_to :organization
    validate :organization_id_exists
    has_many :application_categories
    has_many :categories, through: :application_categories

    def organization_id_exists
        if !Organization.where(organization_id: self.organization_id).exists? then
            errors.add(:organization_id, 'Must have a valid organization ID.')
        end
    end
end
