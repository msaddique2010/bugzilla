class BugReport < ApplicationRecord
  belongs_to :bug
  validates :title, :description, presence: true
end
