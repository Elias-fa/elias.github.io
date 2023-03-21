class User < ApplicationRecord
  has_secure_password

  has_many :messages 

  validates :name, presence: true

  validates :email, presence: true,
                    format: { with: /\S+@\S+/ },
                    uniqueness: { case_sensitive: false }
                    

  validates :password, length: { minimum: 10, allow_blank: true }

  validates :username, presence: true,
                     format: { with: /\A[A-Z0-9]+\z/i },
                     uniqueness: { case_sensitive: false }

  
scope :by_name, -> { order(:name) }
scope :all_except, ->(user) { where.not(id: user) }
scope :not_admins, -> { by_name.where(admin: false) }

after_create_commit { broadcast_append_to "users" }
end
