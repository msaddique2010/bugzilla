class RenamePriotityToPriorityInBugs < ActiveRecord::Migration[8.0]
  def change
    # 1. Rename the column
    rename_column :bugs, :priotity, :priority
  end
end
