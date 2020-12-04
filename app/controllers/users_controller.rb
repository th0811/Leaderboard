class UsersController < ApplicationController
  #before_action :require_user_logged_in, only: :input
  before_action :set_user, only: :show
  
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
    @games = @user.games.order(created_at: :desc).page(params[:page])

    @data = []
    i = 0
    @user.players.each do |p|
      @data.push([i, p.user_rate])
      i += 1
    end
    @data.push([i, @user.rating])
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
  
  def autocomplete_name
    # params[:name]の値でUser.nameを前方一致検索、name列だけ取り出し、nilと空文字を取り除いた配列
    names = User.by_name_like(autocomplete_params[:name]).pluck(:name).reject(&:blank?)
    render json: names
    # レスポンスの例: ["てすと１会社","てすと２会社","てすと３会社"]
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
  
  def autocomplete_params
    params.permit(:name)
  end
end