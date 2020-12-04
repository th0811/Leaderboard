class RemoveColumnsInGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :winner_id, :references
    remove_column :games, :winner_rating, :float
    remove_column :games, :loser_id, :references
    remove_column :games, :loser_rating, :float
  end
end
