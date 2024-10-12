module EventsConcern
  extend ActiveSupport::Concern

  def events_filtered(query, page)
    Event.ordered_events.where(sql_query, query: "%#{query}%").paginate(page:, per_page: 6)
  end

  def build_participants(params)
    user_params = params[:participating_users][:user_id].reject(&:blank?)
    return unless user_params.present?

    user_params.each { |user_id| @event.participating_users.build(user_id:) }
  end

  private

  def sql_query
    <<~HEREDOC.squish
      title iLIKE :query
      OR users.first_name iLIKE :query OR users.last_name iLIKE :query OR users.email iLIKE :query
      OR participants_events.first_name iLIKE :query OR participants_events.last_name iLIKE :query
      OR participants_events.email iLIKE :query
      OR CONCAT(users.first_name, ' ', users.last_name) iLIKE :query
      OR CONCAT(participants_events.first_name, ' ', participants_events.last_name) iLIKE :query
    HEREDOC
  end
end
