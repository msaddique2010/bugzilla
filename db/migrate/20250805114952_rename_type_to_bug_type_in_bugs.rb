class RenameTypeToBugTypeInBugs < ActiveRecord::Migration[8.0]
  def change
    rename_column :bugs, :type, :bug_type
  end
end
