# frozen_string_literal: true

class RegistrationsController < ApplicationController
    before_action :authorized_user?, only: %i[change_password destroy]
  
    # Register a new user account
    def create
        user = User.create!(register_params)
        new_activation_key = generate_token(user.id, 52)
        user.update_attribute(:admin_level, 3) if User.all.size <= 1
        if user.update_attribute(:activation_key, new_activation_key)
          ActivationMailer.with(user: user).welcome_email.deliver_later
        end
        json_response({ user: user }, :created)
      end
  
    # Change a user's password if the password is known
    def change_password
      if @current_user.try(:authenticate, params[:user][:old_password])
        if @current_user.update(password_params)
          json_response({ message: 'Password changed successfully' })
        else
          json_response({ errors: @current_user.errors.full_messages }, 400)
        end
      else
        json_response({ errors: 'Incorrect password' }, 401)
      end
    end
  
    # Change a user's password if they have a password reset token
    def change_password_with_token
      token = params[:password_reset_token]
      user = User.find_by(password_reset_token: token) if token.present?
      if user
        # Check if token is still valid
        return json_response({ message: 'Token expired' }, 400) if user.password_token_expired?
  
        if user.update(password_params)
          user.update_attribute(:password_reset_token, nil)
          json_response({ message: 'Password changed successfully' })
        else
          json_response({ errors: user.errors.full_messages }, 400)
        end
      else
        json_response({ errors: 'Invalid Token' }, 401)
      end
    end
  
    # Generate password reset token and send to account's associated email
    def forgot_password
      user = User.find_by(email: params[:email])
      if user
        new_token = generate_token(user.id, 32, true)
        if user.update_attribute(:password_reset_token, new_token)
          user.update_attribute(:password_reset_date, DateTime.now)
          ActivationMailer.with(user: user).password_reset_email.deliver_now
        else
          json_response({ errors: user.errors.full_messages }, 401)
        end
      end
      json_response({ message: 'Password reset information sent to associated account.' })
    end
  
    def destroy
      user = User.find(params[:id])
      # Only allow the owner of the account or an administrator to destroy the account
      unless user == @current_user || @current_user.admin_level >= 1
        return head(401)
      end
  
      user.destroy
      json_response({ message: 'Account deactivated' })
    end
  
    # Link used in account activation email
    def activate_account
      # Set url variable to the front-end url
     
      user = User.find(params[:id])
  
      if user.activation_key == params[:activation_key]
        user.update_attribute(:is_activated, true)
      end
  
      json_response(message: 'Successfully activated account')
      
    end
  
    # Link used in account password reset email
    def password_reset_account
      # Set url variable to the front-end url
      reset_token = params[:password_reset_token]
      url = "https://arn-forum-cms.netlify.app/reset_password?token=#{reset_token}"
  
      redirect_to url
    end
  
    private
  
    def register_params
      # whitelist params
      params.require(:user)
            .permit(:username, :email, :password, :password_confirmation)
    end
  
    def password_params
      # whitelist params
      params.require(:user)
            .permit(:password, :password_confirmation)
    end
  end