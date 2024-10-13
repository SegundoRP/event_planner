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

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.participating_users.build(user: current_user, role: 'organizer')
    build_participants(params[:event])

    if @event.save
      redirect_to events_path, notice: t('.success')
    else
      render :new, status: :unprocessable_entity, alert: flash[:alert] = t(".failure")
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :category, :start_time, :end_time,
                                  :location, participating_users_attributes: [:user_id]).merge(organizer: current_user)
  end
end
