class GamesController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    @games = Game.order(id: :desc).page(params[:page]).per(10)
  end
  
  def show
    @game = Game.find(params[:id])
  end
  
  def create
    user = User.find(params[:loser_id])
    
    game = Game.prep(current_user, user)
    game.description = game_params[:description]
    
    if game.save
      flash[:success] = 'Successfully record a game'
      winner, loser = prep_update(current_user, user)
      
      if winner.save && loser.save
        flash[:success] += ',Successfully update ratings'
      else
        flash[:danger] = 'failed to update ratings'
      end
      
      redirect_to current_user
    else
      flash[:danger] = 'failed to record a game,' + game.errors.full_messages.join(',')
      redirect_to current_user
    end
  end

  private
  
  def game_params
    params.require(:game).permit(:description)
  end

  def prep_update(winner,loser)
    fluc = 0.04 * (loser.rating - winner.rating) + 16
    if fluc > 32
      fluc = 32
    elsif fluc < 1
      fluc = 1
    end
    
    winner.rating += fluc
    winner.wins = winner.won_games.count
    loser.rating -= fluc
    loser.losses = loser.lost_games.count
    
    return winner, loser
  end

end
