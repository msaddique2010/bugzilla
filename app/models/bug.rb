class Bug < ApplicationRecord
  validates :title, :status, :bug_type, presence: true
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  belongs_to :project
  has_many :bug_reports, dependent: :destroy
  has_one_attached :screenshot
  validate :screenshot_type


  private

  def screenshot_type
    if screenshot.attached?
      if screenshot.content_type == "image/png" || screenshot.content_type == "image/gif"
      else
        screenshot.purge
        errors.add :screenshot, "must be a PNG or GIF"
      end
    end
  end
end
