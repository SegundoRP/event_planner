module EventsHelper
  def event_duration(event)
    ((event.end_time - event.start_time) / 60).to_i
  end

  def full_name(user)
    "#{user.first_name} #{user.last_name}"
  end
end
