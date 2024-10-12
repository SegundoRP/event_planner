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
  has_many :participants, through: :participating_users, source: :user

  validates :start_time, :end_time, :title, presence: true

  scope :ordered_events, lambda {
    joins(:organizer, :participants)
      .includes(:organizer, :participants)
      .order(:start_time).distinct
  }

  scope :my_ordered_events, lambda { |user|
    joins(:organizer)
      .includes(:organizer)
      .where(user_id: user.id)
  }
end
