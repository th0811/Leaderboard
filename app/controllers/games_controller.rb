class GamesController < ApplicationController
  before_action :require_user_logged_in, only: [:new, :create, :edit, :update]
  
  def index
    @games = Game.order(id: :desc).page(params[:page]).per(10)
  end
  
  def show
    @game = Game.find(params[:id])
    @comments = @game.comments
    @comment = Comment.new
  end
  
  def new
    @game = Game.new
  end
  
  
  
  def create
    ps = params.require(:user)
    winners = []
    losers = []
    
    ps.each do |p|
      unless p[:winner] == nil
        winners.push(p[:winner])
      end
      unless p[:loser] == nil
        losers.push(p[:loser])
      end
    end
    
    total = winners + losers
    
    if total.count - total.uniq.count > 0
      flash[:danger] = 'プレイヤーが重複しています'
      return render :new
    end
    
    win_users = []
    winners_avg= 0
    winners.each do |winner|
      tmp_user = User.find_by(name: winner)
      unless !!tmp_user
        flash[:danger] = winner + 'というユーザは存在しません'
        return render :new
      end
      win_users.push(tmp_user)
      winners_avg += tmp_user.rating
    end
    winners_avg = winners_avg / win_users.size
    
    lose_users = []
    losers_avg= 0
    losers.each do |loser|
      tmp_user = User.find_by(name: loser)
      unless !!tmp_user
        flash[:danger] = loser + 'というユーザは存在しません'
        return render :new
      end
      lose_users.push(tmp_user)
      losers_avg += tmp_user.rating
    end
    losers_avg = losers_avg / lose_users.size

    f = calc_f(winners_avg, losers_avg)

    game = Game.new(game_params)
    if game.save
      flash[:success] = '試合を記録しました'
    else
      flash[:danger] = '記録に失敗しました,' + game.errors.full_messages.join(',')
      return redirect_to input_path
    end

    win_users.each do |user|
      user.win(game)
      user.update(rating: user.rating + f)
    end
    
    lose_users.each do |user|
      user.lose(game)
      user.update(rating: user.rating - f)
    end
    
    redirect_to game
  end
  
  
  
  def edit
    @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    
    if @game.update(game_params)
      flash[:success] = "内容を更新しました"
      redirect_to @game
    else
      flash.now[:danger] = "更新に失敗しました"
      render :edit
    end
    
  end
  
  private
  
  def game_params
    params.require(:game).permit(:description)
  end

  def calc_f(winner_rate, loser_rate)
    fluc = 0.04 * (loser_rate - winner_rate) + 16
    if fluc > 32
      fluc = 32
    elsif fluc < 1
      fluc = 1
    end
    return fluc
  end

end
