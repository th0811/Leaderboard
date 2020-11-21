class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.references :winner, null:false, foreign_key: { to_table: :users }
      t.float :winner_rating, null:false
      t.references :loser, null:false, foreign_key: { to_table: :users }
      t.float :loser_rating, null:false

      t.timestamps
    end
  end
end
