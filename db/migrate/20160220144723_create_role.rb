class CreateRole < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, index: true

      t.timestamps null: false
    end
  end
end
