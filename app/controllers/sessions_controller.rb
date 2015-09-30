class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    p @user
    p params[:session][:password]
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

end
