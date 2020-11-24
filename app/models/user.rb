class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :won_games, class_name: 'Game', foreign_key: 'winner_id'
  has_many :lost_games, class_name: 'Game', foreign_key: 'loser_id'
  
  def lastgames(num=nil)
    Game.where(winner_id: self.id).or(Game.where(loser_id: self.id)).order('created_at DESC').limit(num)
  end

end
