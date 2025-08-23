class FixPriorityColumnInBugs < ActiveRecord::Migration[8.0]
  def change
    # First, remove the wrongly named column
    remove_column :bugs, :priotity, :text
  end
end
