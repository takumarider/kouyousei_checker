# app/models/answer.rb
class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :option

  validates :session_id, presence: true
end
