class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :won_games, class_name: 'Game', foreign_key: 'winner_id'
  has_many :lost_games, class_name: 'Game', foreign_key: 'loser_id'
  has_many :comments
  
  def lastgames(num=nil)
    Game.where(winner_id: self.id).or(Game.where(loser_id: self.id)).order('created_at DESC').limit(num)
  end

  def rating_data()
    games = Game.where(winner_id: self.id).or(Game.where(loser_id: self.id)).order('created_at ASC')
    data = []
    time = 0
    games.each do |game|
      if game.winner == self
        data.push([time, game.winner_rating])
      elsif game.loser == self
        data.push([time, game.loser_rating])
      end
      time += 1
    end
    data.push([time,self.rating])
    return data
  end

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end

end
