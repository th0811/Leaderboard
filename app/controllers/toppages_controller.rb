class ToppagesController < ApplicationController
  def index
    @users = User.order(rating: :desc).page(params[:page]).per(10)
    @title = 'Leaderboard'
  end
end
