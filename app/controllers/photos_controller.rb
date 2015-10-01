class PhotosController < ApplicationController
  def index
    start = 0
    stop = 19
    @photos = Photo.all.order(created_at: :desc)[start..stop]
    if request.xhr?
      start = params[:start].to_i
      stop = params[:stop].to_i
      if Photo.last.id < start
        return 400
      end
      @photos = Photo.all.order(created_at: :desc)[start..stop]
      render '_photos.json', layout: false
    else
      render 'index'
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @hearts = @photo.hearts.all.order(created_at: :desc)
  end

  def new
    render 'new'
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_to @photo
    else
      @photo = Photo.find_by(url: params[:url])
      @hearts = @photo.hearts.all.order(created_at: :desc)
      flash.now[:notice] = "Someone else beat you to this one!  Here it is."
      render 'show'
    end
  end

  def destroy
  end

  private
    def photo_params
      params.require(:photo).permit(:url)
    end
end
