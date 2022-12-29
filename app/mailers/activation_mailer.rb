class ActivationMailer < ApplicationMailer
    default from: 'forumCMS@notifications.com'
  
    def welcome_email
      @user = params[:user]
      mail(to: @user.email, subject: 'Welcome to the React.js Forum-CMS Demo')
    end
  end