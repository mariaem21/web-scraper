# frozen_string_literal: true

class Contact < ApplicationRecord
    # belongs_to :organization
    has_many :organizations
    # validates :organizations, presence: true
    validate :orgID_exists

    validates :personID, presence: true, uniqueness: true
    validates :orgID, presence: true
    validates :year, presence: true
    validates :name, presence: true
    validates :email, presence: true
    validates :officerposition, presence: true
    validates :description, presence: true

    def orgID_exists
        if !Organization.where(orgID: self.orgID).exists? then
            errors.add(:orgID, 'Must have a valid organization ID.')
        end
    end
end
