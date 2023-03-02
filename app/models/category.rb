class Category < ApplicationRecord
    has_many :appcats
    has_many :applications, through: :appcats

    validates :categoryID, presence: true, uniqueness: true
    validates :name, presence: true
    validates :description, presence: true
    validates :appcats, presence: true
end
