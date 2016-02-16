class CreateClientApplications < ActiveRecord::Migration
  def change
    create_table :client_applications do |t|
      t.string :name
      t.string :app_id
      t.string :app_secret
      t.boolean :access_granted, default: false

      t.timestamps null: false
    end
  end
end
