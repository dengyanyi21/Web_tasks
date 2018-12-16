class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :feedbacks
  validates :username, presence: { message: 'can\'t be blank' }
  validates :username, uniqueness: { message: 'already exists' }
  has_secure_password
  validates :password, length: { minimum: 6, message: 'length should be longer than 6 digits' }
  validates :password_confirmation, presence: { message: 'can\'t be blank' }
  validates :email, presence: { message: 'can\'t be blank' }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'address is incorrect' }
end
