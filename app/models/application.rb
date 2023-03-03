class Application < ApplicationRecord
  validates :applicationID, presence: true, uniqueness: true
  validate :if_applicationid_negative
  validates :orgID, presence: true
  validate :orgid_exists
  validate :if_orgid_negative
  validates :name, presence: true
  validates :datebuilt, presence: true
  validates :githublink, presence: true
  validates :description, presence: true
  # has_one :contact
  # validates :contact, presence: true
  # belongs_to :organization
  has_many :appcats
  has_many :categories, through: :appcats

  def orgid_exists
    if !Organization.where(orgID: self.orgID).exists? then
      errors.add(:orgID, 'must have a valid organization ID')
    end
  end

  def if_orgid_negative
    if :orgID.blank?
      if orgID < 1
        errors.add(:orgID, 'cannot be less than 1')
      end
    end
  end

  def if_applicationid_negative
    if :applicationID.blank?
      if applicationID < 1
        errors.add(:applicationID, 'cannot be less than 1')
      end
    end
  end
end
