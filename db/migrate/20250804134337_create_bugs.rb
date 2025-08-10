class CreateBugs < ActiveRecord::Migration[8.0]
  def change
    create_table :bugs do |t|
      t.string :title
      t.text :description
      t.text :priotity

      t.timestamps
    end
  end
end
