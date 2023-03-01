class Application < ApplicationRecord
    validates :applicationID, presence: true
    validates :orgID, presence: true
    validates :name, presence: true
end
