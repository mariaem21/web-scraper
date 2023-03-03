# frozen_string_literal: true

class Application < ApplicationRecord
    validates :applicationID, presence: true, uniqueness: true, comparison: { greater_than: 0 }
    validates :orgID, presence: true, comparison: { greater_than: 0 }
    validate :orgID_exists
    validates :name, presence: true
    validates :datebuilt, presence: true
    validates :githublink, presence: true
    validates :description, presence: true
    # has_one :contact
    # validates :contact, presence: true
    # belongs_to :organization
    has_many :appcats
    has_many :categories, through: :appcats

    def orgID_exists
        if !Organization.where(orgID: self.orgID).exists? then
            errors.add(:orgID, 'Must have a valid organization ID')
        end
    end
end
