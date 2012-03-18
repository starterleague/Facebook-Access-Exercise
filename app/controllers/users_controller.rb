require 'open-uri'

class UsersController < ApplicationController
  def facebook_callback
    if code = params[:code]
      user = User.find(session[:user_id])
      response = open("https://graph.facebook.com/oauth/access_token?client_id=#{ENV['FACEBOOK_APP_ID']}&redirect_uri=http://localhost:3000/facebook_callback&client_secret=#{ENV['FACEBOOK_APP_SECRET']}&code=#{code}").read
      access_token = response.split("&")[0].split("=")[1]
      user.facebook_access_token = access_token
      user.save
      redirect_to user_url(user), :notice => "Facebook access granted."
    else
      redirect_to root_url, :notice => "Facebook access not granted."
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    
    if @user.facebook_access_token
      @image_uri = open("https://graph.facebook.com/me/picture?access_token=#{@user.facebook_access_token}").base_uri
      links_response = open("https://graph.facebook.com/me/links?access_token=#{@user.facebook_access_token}").read
      @links = JSON.parse(links_response)["data"]
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
end
