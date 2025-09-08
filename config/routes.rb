Rails.application.routes.draw do
  # 質問一覧＆スコア送信
  resources :questions, only: [ :index ] do
    collection do
      post :submit # /questions/submit にPOST
    end
  end

  # 診断結果表示
  resources :results, only: [ :show ], param: :id
end
