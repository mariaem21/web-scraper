class Application < ApplicationRecord
<<<<<<< HEAD
    validates :applicationID, presence: true
    validates :orgID, presence: true
    validates :name, presence: true
=======
    validates :applicationID, presence: true, uniqueness: true
    validates :orgID, presence: true
    validates :name, presence: true
    validates :datebuilt, presence: true
    validates :githublink, presence: true
    validates :description, presence: true
    
    # has_one :contact
    # validates :contact, presence: true
    # belongs_to :organization
    validate :orgID_exists
    has_many :appcats
    has_many :categories, through: :appcats

    def orgID_exists
        if !Organization.where(orgID: self.orgID).exists? then
            errors.add(:orgID, 'Must have a valid organization ID.')
        end
    end
>>>>>>> 6e289dd491e82e02e7afe870b620ce0ad68dfc7e
end
