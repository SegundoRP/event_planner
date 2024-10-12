# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  role                   :integer          default("employee"), not null
#  first_name             :string           not null
#  last_name              :string           not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  format_name = /\A[^0-9`!@#$%\^&*+_=]+\z/

  has_many :organized_events, class_name: 'Event', foreign_key: 'user_id'
  has_many :participations, class_name: 'Participant'
  has_many :events, through: :participations

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true, format: { with: format_name }, length: { minimum: 2 }

  enum role: { admin: 0, employee: 1 }
end
