class SessionsController < ApplicationController
  def new
    @user = User.new
    if request.xhr?
      render 'new', layout: false
    end
  end

  def create
    @user = User.find_by(username: params[:session][:username])
    p @user
    p params[:session][:password]
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      redirect_to @user
    else
      flash.now[:notice] = 'your login information was incorrect. puppies don\'t like hackers.'
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:notice] = 'you have successfully logged out.'
    redirect_to root_url
  end

end
