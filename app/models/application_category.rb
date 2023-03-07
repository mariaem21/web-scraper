# frozen_string_literal: true

class ApplicationCategory < ApplicationRecord
    validates :application_category_id, presence: true, uniqueness: true,  comparison: { greater_than: 0 }
    validates :application_id, presence: true, comparison: { greater_than: 0 }
    validates :category_id, presence: true, comparison: { greater_than: 0 }
    validate :category_id_exists
    validate :application_id_exists



    def category_id_exists
        if !Category.where(category_id: self.category_id).exists? then
            errors.add(:category_id, 'Must have a valid category ID.')
        end
    end

    def application_id_exists
        if !Application.where(application_id: self.application_id).exists? then
            errors.add(:application_id, 'Must have a valid application ID.')
        end
    end
end
