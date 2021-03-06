class PhotosController < ApplicationController
  include ApplicationHelper
  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all.select do |p|
      p.may_view session[:user]
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
    @photo = Photo.find(params[:id]) rescue nil

    
    if @photo and @photo.may_view session[:user]
      respond_to do |format|
        format.html # show.html.erb
        format.json { render :json => @photo }
      end
    else
      redirect_to photos_path
    end
  end

  # GET /photos/new
  # GET /photos/new.json
  def new
    unless session[:user]
      redirect_to url_for :controller => :users, :action => :login
    else
      @photo = Photo.new
    end
    
  end

  # GET /photos/1/edit
  def edit
    @user = session[:user]
    @photo = Photo.find(params[:id])
    @allowed = (@user == @photo.user)
  end

  # POST /photos
  # POST /photos.json
  def create
    @photo = Photo.new(params[:photo])

    @photo.user = session[:user]

    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, :notice => 'Photo was successfully uploaded!' }
        format.json { render :json => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.json { render :json => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.json
  def update
    @photo = Photo.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to @photo, :notice => 'Photo was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photo = Photo.find(params[:id])
    @user = @photo.user
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to @user, :notice => "Your picture is gone forever now. Forever." }
      format.json { head :no_content }
    end
  end
end
