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

      # セッションIDを生成（UUIDを使用）
      session_id = SecureRandom.uuid

      # 回答を保存
      Answer.transaction do
        answers.each do |question_id, option_id|
          Answer.create!(
            session_id: session_id,
            question_id: question_id.to_i,
            option_id: option_id.to_i
          )
        end
      end

      # 結果ページにリダイレクト
      redirect_to result_path(id: session_id)
    end
end
