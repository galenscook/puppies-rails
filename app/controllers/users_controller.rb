class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    start = 0
    stop = 19
    @photos = @user.hearts.order(created_at: :desc)[start..stop]
    if request.xhr?
      start = params[:start].to_i
      stop = params[:stop].to_i
      if @photos.last.id < start
        return 400
      end
      @photos = @user.photos.order(created_at: :desc)[start..stop]
      render '/photos/_photos.json', layout: false
    else
      render 'show'
    end
  end

  def new
    @user = User.new
    if request.xhr?
      render 'new', layout: false
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)

    if @user.save
      log_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def update
    @user = User.find(params[:id])
    p old_password = params[:user][:password_old]
    if (@user.password == old_password) && @user.update(user_params)
      redirect_to @user
    elsif @user.password != old_password
      flash.now[:notice] = "your old password was incorrect.  puppies don't like hackers."
      render 'edit'
    else
      render 'edit'
    end
  end

  def destroy
    if is_admin? || current_user.id.to_s == params[:id]
      user = User.find(params[:id])
      user.destroy
      if !is_admin?
        log_out
      end
      flash.now[:notice] = 'you have successfully deleted your account.  we will miss you.'
      redirect_to photos_path
    else 
      flash.now[:error] = 'you don\'t have access to this area.  sorry.'
    end
  end

  private
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
