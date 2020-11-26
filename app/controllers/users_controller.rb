class UsersController < ApplicationController
  before_action :require_user_logged_in, only: :input
  before_action :set_user, only: [:show, :input]
  
  def index
    @users = User.search(params[:search]).order(name: :asc).page(params[:page]).per(10)
    if params[:search]
      @title = 'Search Results'
      @need_back = "need"
    else
      @title = 'Users list'
    end
  end

  def show
    @games = @user.lastgames.page(params[:page]).per(10)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'You are registered. Please Log in'
      redirect_to login_url
    else
      flash.now[:danger] = 'You have failed to register'
      render :new
    end
  end
  
  def input
    game = Game.prep(current_user,@user)
    
    if game.save
      flash[:success] = 'Successfully record a game'
      winner, loser = prep_update(current_user, @user)
      
      if winner.save && loser.save
        flash[:success] += ',Successfully update ratings'
      else
        flash[:danger] = 'failed to update ratings'
      end
      
      redirect_to current_user
    else
      flash[:danger] = 'failed to record a game,' + game.errors.full_messages.join(',')
      redirect_to @user
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def set_user
    @user = User.find_by(id: params[:id])
    if !@user
      flash[:danger] = 'the user does not exist'
      redirect_to root_url
    end
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