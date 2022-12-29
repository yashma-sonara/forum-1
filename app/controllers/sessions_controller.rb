# frozen_string_literal: true

class SessionsController < ApplicationController
    before_action :authorized_user?, except: :create
  
    # When a user attempts to log in
    def create
      user = User.where(username: params[:user][:username].downcase)
                 .or(User.where(email: params[:user][:email].downcase))
                 .first
  
      return json_response({ errors: 'Incorrect login credentials' }, 401) unless user
  
      authenticate_user(user)
    end
  
    # When a user logs out
    def destroy
      @current_user.update(token: nil)
      json_response(user: { logged_in: false })
    end
  
    # Checks if a user is still logged in
    def logged_in
      json_response(user: user_status(@current_user))
  
      # json_response(user: { logged_in: false }) if params[:token].blank?
  
      # user = User.where(token: params[:token]).first
      # if @current_user
      #   json_response(user: user_status(@current_user))
      # else json_response(user: { logged_in: false })
      # end
    end
  
    private
  
    def user_status(user)
      user_with_status = user.as_json(only: %i[id username is_activated
                                               token admin_level can_post_date
                                               can_comment_date])
      user_with_status['logged_in'] = true
      user_with_status['can_post'] = DateTime.now > user.can_post_date
      user_with_status['can_comment'] = DateTime.now > user.can_comment_date
  
      user_with_status
    end
  
    def authenticate_user(user)
      if user.try(:authenticate, params[:user][:password])
        return unless activated(user)
  
        new_token = generate_token(user.id)
        if user.update_attribute(:token, new_token)
          user.update_attribute(:token_date, DateTime.now)
          json_response(user: user_status(user))
        else
          json_response({ errors: user.errors.full_messages }, 401)
        end
      else
        json_response({ errors: 'Incorrect login credentials' }, 401)
      end
    end
  
    def activated(user)
      unless user.is_activated
        json_response({ errors: ['Account not activated'] }, 401)
        return false
      end
  
      true
    end
  end