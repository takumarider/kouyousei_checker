# app/models/question.rb
class Question < ApplicationRecord
    has_many :options, dependent: :destroy
    has_many :answers, dependent: :destroy
  
    validates :content, presence: true, length: { maximum: 2000 }
  end
  