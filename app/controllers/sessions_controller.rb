class SessionsController < ApplicationController
  before_action :logged_in_redirect, only: [:new, :create]
  
  def new

  end

  def create
    if params[:signup]
      create_new_user
    else
      log_in_user
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have successfully logged out"
    redirect_to login_path
  end

  private

  def logged_in_redirect
    if logged_in?
      flash[:error] = "You are already logged in"
      redirect_to root_path
    end
  end

  def log_in_user
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = "You have successfully logged in"
      redirect_to root_path
    else
      flash.now[:error] = "There was something wrong with you login information"
      render 'new'
    end
  end

  def create_new_user
    user = User.create(username: params[:session][:username], password: params[:session][:password])
    if user.save
      flash[:success] = "Welcome to TannerChat"
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash[:error] = user.errors.full_messages
      render 'new'
    end
  end

end