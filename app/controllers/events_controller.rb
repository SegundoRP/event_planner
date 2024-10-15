class EventsController < ApplicationController
  include EventsConcern
  def index
    if params[:query].blank?
      @events = Event.ordered_events.paginate(page: params[:page], per_page: 6)
    else
      @events = events_filtered(params[:query], params[:page])
    end

    @events = @events.where(participants: { id: current_user.id }) if current_user.employee?
  end

  def my_events
    @events = Event.my_ordered_events(current_user).paginate(page: params[:page], per_page: 6)
  end
end
