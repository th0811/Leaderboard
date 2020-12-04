class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.references :game, foreign_key: true
      t.references :user, foreign_key: true
      t.float :user_rate
      t.boolean :wl

      t.timestamps
      
      t.index [:user_id, :game_id], unique: true
    end
  end
end
