# frozen_string_literal: true

class Category < ApplicationRecord
    has_many :application_categories
    has_many :applications, through: :application_categories

    validates :category_id, presence: true, uniqueness: true
    validates :name, presence: true
    validates :description, presence: true
    # validates :application_categories, presence: true
end
