# == Schema Information
#
# Table name: events
#
#  id           :bigint           not null, primary key
#  start_time   :datetime         not null
#  end_time     :datetime         not null
#  title        :string           not null
#  description  :text
#  category     :string
#  location     :string
#  weather_data :jsonb
#  user_id      :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Event < ApplicationRecord
  belongs_to :organizer, class_name: 'User', foreign_key: 'user_id'

  has_many :participating_users, class_name: 'Participant', dependent: :destroy_async
  has_many :participants, through: :participating_users, class_name: 'User', source: :user

  validates :start_time, :end_time, :title, presence: true
  validate :check_for_overlapping_events, on: :create
  validate :start_time_minors_than_end_time, on: :create
  validate :end_time_greater_than_start_time, on: :create

  after_validation :fetch_weather_data, if: :saved_change_to_location?
  after_validation :fetch_weather_data, if: :will_save_change_to_location?

  scope :ordered_events, lambda {
    includes(:organizer, :participants)
      .order(:start_time).distinct
  }

  scope :my_ordered_events, lambda { |user|
    joins(:organizer)
      .includes(:organizer)
      .where(user_id: user.id)
  }

  def check_for_overlapping_events
    return unless Event.overlapping_events?(user_id, start_time, end_time)

    errors.add(:start_time, I18n.t('activerecord.attributes.event.overlapping_events'))
  end

  def self.overlapping_events?(user_id, start_time, end_time)
    joins(:participating_users)
      .where(participating_users: { user_id: })
      .where("start_time < ? AND end_time > ?", end_time, start_time).exists?
  end

  def start_time_minors_than_end_time
    return if start_time.blank? || end_time.blank?
    return unless start_time.presence > end_time.presence

    errors.add(:start_time, I18n.t('activerecord.attributes.event.greater_than_end_time'))
  end

  def end_time_greater_than_start_time
    return if start_time.blank? || end_time.blank?
    return unless end_time < start_time

    errors.add(:end_time, I18n.t('activerecord.attributes.event.minor_than_start_time'))
  end

  def fetch_weather_data
    if location.present?
      data = WeatherDataDto.new(open_weather_client.fetch_weather_data(location))
      self.weather_data = data.as_json
    else
      self.weather_data = nil
    end
  rescue NoMethodError
    self.weather_data = nil
  end

  def open_weather_client
    @open_weather_client ||= OpenWeatherClient.new
  end
end
