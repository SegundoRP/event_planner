class Api::V1::EventsController < ActionController::API
  def index
    if params[:participant_id].present?
      @events = Event.ordered_events
                     .joins(:participating_users)
                     .where(participating_users: { user_id: params[:participant_id] })
                     .paginate(page: params[:page], per_page: 6)
    else
      @events = Event.ordered_events.paginate(page: params[:page], per_page: 6)
    end

    render json: EventSerializer.new(@events, { is_collection: true }).serializable_hash, status: :ok
  end

  def show
    @event = Event.find(params[:id])

    render json: EventSerializer.new(@event), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Event not found' }, status: :not_found
  end
end
