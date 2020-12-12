class User < ApplicationRecord
  validates :username, :email, :phone_number, presence: true
  validates :username, :email, uniqueness: true
end
