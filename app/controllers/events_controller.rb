class EventsController < ApplicationController
  include EventsConcern
  before_action :event, only: %i[show destroy edit update]
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
      EventMailer.notify_new_event(@event).deliver_later
      redirect_to events_path, notice: t('.success')
    else
      render :new, status: :unprocessable_entity, alert: flash[:alert] = t(".failure")
    end
  end

  def show; end

  def edit; end

  def update
    build_participants(params[:event])
    if @event.update(event_params)
      redirect_to events_path, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity, alert: flash[:alert] = t(".failure")
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, status: :see_other, notice: t('.success')
  end

  private

  def event
    @event ||= Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :category, :start_time, :end_time,
                                  :location, participating_users_attributes: [:user_id]).merge(organizer: current_user)
  end
end
