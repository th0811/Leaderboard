class Game < ApplicationRecord
  validates :description, length: { maximum: 2000 }
  
  has_many :players
  has_many :users, through: :players, source: :user
  has_many :comments

  def winners
    self.players.where(wl: true)
  end
  
  def losers
    self.players.where(wl: false)
  end
end
