class PushNotificationUtils
  def send_notification
    Gcm::Notification.send_notifications
  end
  handle_asynchronously :send_notification
end