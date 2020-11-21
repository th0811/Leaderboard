class UsersController < ApplicationController
  before_action :require_user_logged_in, only: :input
  before_action :set_user, only: [:show, :input]
  
  def index
    @users = User.order(name: :asc).page(params[:page]).per(10)
    @title = 'Users list'
  end

  def show
    @games = @user.lastgames(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'You are registered。'
      redirect_to login_url
    else
      flash.now[:danger] = 'You have failed to register。'
      render :new
    end
  end
  
  def input
    game = Game.prep(current_user,@user)

    if game.save
      flash[:success] = 'Successfully recorded'
      redirect_to current_user
    else
      flash[:danger] = game.errors.full_messages.join(',')
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
  
end