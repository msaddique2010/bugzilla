class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :projects, dependent: :destroy
  has_many :bugs, dependent: :destroy
  has_many :created_bugs, class_name: "Bug", foreign_key: "user_id", dependent: :destroy
end
