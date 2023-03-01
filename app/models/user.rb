class User < ApplicationRecord
    validates :userID, presence: true, uniqueness: true
    validates :name, presence: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    validates :isadmin, presence: true
end
