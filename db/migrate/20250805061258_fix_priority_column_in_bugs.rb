class FixPriorityColumnInBugs < ActiveRecord::Migration[8.0]
  def change
    # First, remove the wrongly named column
    remove_column :bugs, :priotity, :text

    # Then, add the correct column with correct type
    add_column :bugs, :priority, :string
  end
end
