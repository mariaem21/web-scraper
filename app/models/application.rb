class Application < ApplicationRecord
    validates :applicationID presence: true
    validates :orgID presence: true
    validates :name presence: true
    validates :datebuilt presence: true
    validates :githublink presence: true
    validates :description presence: true
end
