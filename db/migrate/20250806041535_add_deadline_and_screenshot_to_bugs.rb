class AddDeadlineAndScreenshotToBugs < ActiveRecord::Migration[8.0]
  def change
    add_column :bugs, :deadline, :datetime
    add_column :bugs, :screenshot, :string
  end
end
