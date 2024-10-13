class EventMailer < ApplicationMailer
  def notify_new_event(event)
    @event = event
    emails = @event.participants.pluck(:email)
    # If the emails are not allowed in mailgun (since is a free account), the email won't be sent
    mail(to: emails, subject: I18n.t('mailer.event_mailer.new_event_created'))
  end
end
