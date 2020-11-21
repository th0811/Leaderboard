class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.float :rating, null:false, default: 1600
      t.integer :wins, null:false, default: 0
      t.integer :losses, null:false, default: 0

      t.timestamps
    end
  end
end
