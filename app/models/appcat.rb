# frozen_string_literal: true

class Appcat < ApplicationRecord
    belongs_to :category
    belongs_to :application
    
    validates :appcatID, presence: true, uniqueness: true
    validates :categoryID, presence: true
    validates :applicationID, presence: true
end
