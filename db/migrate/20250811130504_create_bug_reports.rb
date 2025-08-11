class CreateBugReports < ActiveRecord::Migration[8.0]
  def change
    create_table :bug_reports do |t|
      t.references :bug, null: false, foreign_key: true
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
