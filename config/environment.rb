# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
BetchaServer::Application.initialize!

module ActiveSupport
  class BufferedLogger
    def add(severity, message = nil, progname = nil, &block)
      return if @level > severity
      message = (message || (block && block.call) || progname).to_s

      level = {
        0 => "DEBUG",
        1 => "INFO",
        2 => "WARN",
        3 => "ERROR",
        4 => "FATAL"
      }[severity] || "U"

      message = "[%s: %s #%d] %s" % [level,
                                     Time.now.strftime("%m%d %H:%M:%S"),
                                     $$,
                                     message]

      message = "#{message}\n" unless message[-1] == ?\n
      buffer << message
      auto_flush
      message
    end
  end
  
#  config.action_mailer.delivery_method = :smtp
#  config.action_mailer.smtp_settings = {
#  :address              => "smtp.gmail.com",
#  :port                 => 587,
#  :domain               => 'www.dropabet.com',
#  :user_name            => 'marketing',
#  :password             => 'dropabet',
#  :authentication       => 'plain',
#  :enable_starttls_auto => true  }
end
