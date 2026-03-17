class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_or_initialize_by(email: auth["info"]["email"])

    user.nickname = auth["info"]["nickname"]
    user.token = auth["credentials"]["token"]

    user.save!

    session[:user_id] = user.id
    flash[:notice] = "Logged in as #{user.nickname}"
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "Logged out"
    redirect_to root_path
  end
end
