# frozen_string_literal: true

class User < ApplicationRecord
    validates :user_id, presence: true, uniqueness: true
    validates :name, presence: true
    validates :username, presence: true, uniqueness: true
    validates :password, presence: true
    validates :is_admin, presence: true
end
