# app/models/option.rb
class Option < ApplicationRecord
  belongs_to :question
  has_many :answers, dependent: :restrict_with_exception

  validates :label, presence: true
  validates :score, presence: true, numericality: { only_integer: true }
end
