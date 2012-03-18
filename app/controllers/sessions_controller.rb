class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user_url(user), :notice => 'Signed in successfully.'
    else
      redirect_to root_url, :notice => 'Sign in unsuccessful. Please try again.'
    end
  end
  
  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out successfully.'
  end
end