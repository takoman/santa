class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, index: true
      t.string :password_digest
      t.string :phone
      t.string :gender
      t.date :birthday
      t.text :notes
      t.boolean :enabled, default: true

      t.timestamps null: false
    end
  end
end
