class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :players
  has_many :games, through: :players, source: :game
  has_many :comments
  
  scope :by_name_like, lambda { |name|
    where('name LIKE :value', { value: "#{sanitize_sql_like(name)}%"})
  }
  
  def win(game)
    self.players.find_or_create_by(game_id: game.id, user_rate: self.rating, wl: true)
    self.update(wins: self.wins+1)
  end
  
  def lose(game)
    self.players.find_or_create_by(game_id: game.id, user_rate: self.rating, wl: false)
    self.update(losses: self.losses+1)
  end
  
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
