class Application < ApplicationRecord
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
  validate :if_orgID_negative
  validate :if_applicationID_negative
  has_many :appcats
  has_many :categories, through: :appcats

  def orgID_exists
    if !Organization.where(orgID: self.orgID).exists? then
      errors.add(:orgID, 'must have a valid organization ID')
    end
  end

  def if_orgID_negative
    if :orgID < 1 then
      errors.add(:orgID, 'cannot be less than 1')
    end
  end

  def if_applicationID_negative
    if :applicationID < 1 then
      errors.add(:applicationID, 'cannot be less than 1')
    end
  end
end
