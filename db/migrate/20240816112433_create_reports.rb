class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true, null: false
      t.string :title, null: false, limit: 50
      t.string :content, null: false, limit: 100

      t.timestamps
    end
  end
end
