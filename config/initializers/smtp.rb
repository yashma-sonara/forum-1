ActionMailer::Base.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'polar-ocean-04755.herokuapp.com',
  user_name: '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',
  password: ENV['app288756445'],
  authentication: :plain
  
}