Rails.application.routes.draw do
  # 質問一覧＆スコア送信
  resources :questions, only: [ :index ] do
    collection do
      post :submit # /questions/submit にPOST
    end
  end
end
