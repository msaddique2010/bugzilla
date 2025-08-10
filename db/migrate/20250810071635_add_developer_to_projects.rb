class AddDeveloperToProjects < ActiveRecord::Migration[8.0]
  def change
    add_reference :projects, :developer, null: true, foreign_key: { to_table: :users }
  end
end
