class Game < ApplicationRecord
  belongs_to :winner, class_name: 'User'
  belongs_to :loser, class_name: 'User'
  
  validates :winner, presence: true
  validates :winner_rating, presence: true
  validates :loser, presence: true
  validates :loser_rating, presence: true
  validate :winner_and_loser_cannot_be_same
  
  def winner_and_loser_cannot_be_same
    if winner == loser
      errors.add(:base, "winner and loser cannot be same")
    end
  end
  
  def self.prep(winner,loser)
    game = self.new(winner_id: winner.id, winner_rating: winner.rating, loser_id: loser.id, loser_rating: loser.rating)
    
    fluc = 0.04 * (loser.rating - winner.rating) + 16
    if fluc > 32
      fluc = 32
    elsif fluc < 1
      fluc = 1
    end
    
    winner.update(rating: winner.rating + fluc, wins: winner.wins + 1)
    loser.update(rating: loser.rating - fluc, losses: loser.losses + 1)
    return game
  end
end
