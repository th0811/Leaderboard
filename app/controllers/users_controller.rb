class UsersController < ApplicationController
  def index
    @users = User.order(name: :asc).page(params[:page]).per(10)
    @title = 'Users list'
  end

  def show
    @user = User.find(params[:id])
    #@game = Game.find_by(winner_id: @user.id)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
    
  private
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
