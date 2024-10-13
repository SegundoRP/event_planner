class EventMailer < ApplicationMailer
  def notify_new_event(event)
    @event = event
    mail(to: @event.organizer.email, subject: I18n.t('mailer.event_mailer.new_event_created'))
  end
end
