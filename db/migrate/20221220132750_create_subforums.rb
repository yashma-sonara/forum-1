class CreateSubforums < ActiveRecord::Migration[6.0]
  def change
    create_table :subforums do |t|
      t.string :name
      t.belongs_to :forum, null: false, foreign_key: true

      t.timestamps
    end
  end
end