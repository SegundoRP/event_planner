# == Schema Information
#
# Table name: participants
#
#  id         :bigint           not null, primary key
#  role       :integer          default("attendant"), not null
#  user_id    :bigint           not null
#  event_id   :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum role: { organizer: 0, attendant: 1 }
end
