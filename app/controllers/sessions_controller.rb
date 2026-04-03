# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_initialize_by(email: auth['info']['email'])

    user.nickname = auth['info']['nickname']
    user.token = auth['credentials']['token']

    user.save!

    session[:user_id] = user.id
    flash[:notice] = t('.logged_in', nickname: user.nickname)
    redirect_to root_path
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = t('.logged_out')
    redirect_to root_path
  end
end 
