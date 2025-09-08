# frozen_string_literal: true

class ResultsController < ApplicationController
  def show
    # URLパラメータからセッションIDを取得
    session_id = params[:id]
    
    # 該当セッションの回答を取得
    answers = Answer.where(session_id: session_id).includes(:option)
    
    # 回答が存在しない場合は診断画面へリダイレクト
    if answers.empty?
      return redirect_to questions_path, alert: "診断結果が見つかりませんでした。"
    end
    
    # 合計スコアを算出
    @total_score = answers.joins(:option).sum("options.score")
    
    # 診断結果を取得（範囲一致）
    @result = Result.where("min_score <= ? AND max_score >= ?", @total_score, @total_score).first
    
    # 結果が見つからない場合のエラーハンドリング
    unless @result
      return redirect_to questions_path, alert: "診断結果の判定に失敗しました。"
    end
    
    @session_id = session_id
  end
end