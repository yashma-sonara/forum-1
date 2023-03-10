class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.references :forum, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :subforum, null: true
      t.boolean :is_pinned, default: false
      t.boolean :is_locked, default: false

      t.timestamps
    end
  end
end