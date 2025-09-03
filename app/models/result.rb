# app/models/result.rb
class Result < ApplicationRecord
    # 単独保持（他モデルに紐づけない）
    validates :min_score, :max_score, presence: true, numericality: { only_integer: true }
    validates :level, :comment, presence: true

    validate :score_range_order

    private

    def score_range_order
      if min_score && max_score && max_score < min_score
        errors.add(:max_score, "must be greater than or equal to min_score")
      end
    end
end
