class AddUserIdToBugs < ActiveRecord::Migration[8.0]
  def change
    add_reference :bugs, :user, foreign_key: true
  end
end
