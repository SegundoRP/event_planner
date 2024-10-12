module EventsHelper
  def event_duration(event)
    ((event.end_time - event.start_time) / 60).to_i
  end
end
