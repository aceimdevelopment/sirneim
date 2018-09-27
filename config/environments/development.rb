Sirneim::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
     :address              => "smtp.gmail.com",
      # :address              => "strix.ciens.ucv.ve",
     :port                 => 587,
     :domain               => 'gmail.com',
     :user_name            => 'sirneim',
    #  :user_name            => 'andresviviani3',
    #  :password             => 'aceimaceim',
      # :user_name            => 'sergio.rivas',
     :password             => 'julio2015',
      # :password             => 'aqsw123',
      :authentication       => 'plain',
      :enable_starttls_auto => true  }
end

=begin                            
Aceim::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Excepcion en ACEIM_DIPLOMADOS] ",
  :sender_address => %{"Notificador ACEIM_DIPLOMADOS" <diplomado.ele.eim.ucv@gmail.com>},
  :exception_recipients => %w{sergiorivas@gmail.com andresviviani1@gmail.com}
=end
