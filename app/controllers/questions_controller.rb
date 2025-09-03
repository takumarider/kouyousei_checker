# frozen_string_literal: true

class QuestionsController < ApplicationController
    def index
      # 全問と、それぞれの選択肢（5段階）をEager Load
      @questions = Question.includes(:options).order(:id)
    end

    def submit
      # params[:answers] は {"<question_id>":"<option_id>", ...} の形を想定
      unless params[:answers].is_a?(ActionController::Parameters) || params[:answers].is_a?(Hash)
        return redirect_to questions_path, alert: "全ての設問に回答してください。"
      end

      answers = params[:answers].to_unsafe_h
      question_ids = Question.order(:id).pluck(:id)
      # 全問回答必須（サーバサイド）
      if (question_ids - answers.keys.map(&:to_i)).any?
        return redirect_to questions_path, alert: "全ての設問に回答してください。"
      end

      # 合計スコアを算出
      option_ids = answers.values.map(&:to_i)
      total_score = Option.where(id: option_ids).sum(:score)

      # 診断結果を取得（範囲一致）
      @result = Result.where("min_score <= ? AND max_score >= ?", total_score, total_score).first
      @total_score = total_score

      # 結果画面を表示（簡易）
      render :result, status: :ok
    end
end
