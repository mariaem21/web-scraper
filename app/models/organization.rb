# frozen_string_literal: true

class Organization < ApplicationRecord
    has_many :applications
    has_many :contacts

    validates :organization_id, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true
end
