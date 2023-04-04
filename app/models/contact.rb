# frozen_string_literal: true

class Contact < ApplicationRecord
    # has_many :organizations
    # validate :organization_id_exists
    has_many :contact_organizations
    has_many :organizations, through: :contact_organizations

    validates :contact_id, presence: true, uniqueness: true
    validates :year, presence: true
    validates :name, presence: true
    validates :email, presence: true
    validates :officer_position, presence: true
    validates :description, presence: true

    # def organization_id_exists
    #     if !Organization.where(organization_id: self.organization_id).exists? then
    #         errors.add(:organization_id, 'Must have a valid organization ID.')
    #     end
    # end
end
