
class CreateForums < ActiveRecord::Migration[6.0]
  def change
    create_table :forums do |t|
      t.string :name
      t.boolean :admin_only, default: false
      t.boolean :admin_only_view, default: false

      t.timestamps
    end
  end
end
