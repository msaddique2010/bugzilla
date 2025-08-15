class Project < ApplicationRecord
  belongs_to :user
  has_many :bugs, -> { order(created_at: :desc) }, dependent: :destroy
  belongs_to :developer, class_name: "User", optional: true
  belongs_to :creator, class_name: "User", foreign_key: "user_id"

end
