class Admin < ApplicationRecord
  validates :username, presence: { message: 'can\'t be blank' }
  validates :username, uniqueness: { message: 'already exists' }
  has_secure_password
  validates :password, length: { minimum: 6, message: 'length should be longer than 6 digits' }
  validates :password_confirmation, presence: { message: 'can\'t be blank' }
end
