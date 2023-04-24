# frozen_string_literal: true

class Organization < ApplicationRecord
    has_many :contact_organizations
    has_many :contacts, through: :contact_organizations

    validates :organization_id, presence: true, uniqueness: true
    validates :name, presence: true
    validates :description, presence: true
end
