# db/seeds.rb
# frozen_string_literal: true

# ===== 初期化（FK整合性を保ちつつ高速削除 & PKリセット）=====
ActiveRecord::Base.transaction do
    # 子 → 親 の順で削除
    Answer.delete_all
    Option.delete_all
    Question.delete_all
    Result.delete_all

    tables  = %w[answers options questions results]
    adapter = ApplicationRecord.connection.adapter_name.downcase

    if adapter.include?("mysql")
      # MySQL: AUTO_INCREMENT をリセット
      ApplicationRecord.connection.execute("SET FOREIGN_KEY_CHECKS = 0")
      tables.each do |t|
        ApplicationRecord.connection.execute("ALTER TABLE #{t} AUTO_INCREMENT = 1")
      end
      ApplicationRecord.connection.execute("SET FOREIGN_KEY_CHECKS = 1")
    elsif adapter.include?("postgresql") || adapter.include?("sqlite")
      # PostgreSQL / SQLite: 既存のヘルパを使用
      tables.each do |t|
        ApplicationRecord.connection.reset_pk_sequence!(t)
      end
    else
      Rails.logger.warn("PK reset unsupported adapter: #{adapter}")
    end
  end

  puts "== 🔧 Reset finished =="

  # ===== 設問（10問） =====
  questions = [
    "新しいことに挑戦するのが好きだ",
    "変化のある環境にワクワクする",
    "楽しいことを見つけるのが得意だ",
    "周りを巻き込んで盛り上げることがある",
    "失敗しても前向きに切り替えられる",
    "好きなことにはとことん没頭する",
    "アイデアがどんどん湧いてくる",
    "自分の気分で周りの空気が変わると感じる",
    "常に面白さや刺激を探している",
    "自分の気持ちを表現するのが得意だ"
  ]

  # ===== 選択肢（5段階・スコア付き）=====
  options = [
    { label: "とても当てはまる", score: 5 },
    { label: "当てはまる", score: 4 },
    { label: "どちらともいえない", score: 3 },
    { label: "あまり当てはまらない", score: 2 },
    { label: "まったく当てはまらない", score: 1 }
  ]

  # ===== 作成（Question と Option）=====
  questions.each do |content|
    q = Question.create!(content: content)
    options.each do |opt|
      Option.create!(question: q, label: opt[:label], score: opt[:score])
    end
  end

  # ===== 診断結果（A〜D）=====
  results = [
    { min_score: 45, max_score: 50, level: "A", comment: "あなたは超・高揚性タイプ！楽しさで人を動かすリーダーです。" },
    { min_score: 35, max_score: 44, level: "B", comment: "あなたは高揚性が高いタイプ。日々を前向きに楽しめていますね。" },
    { min_score: 25, max_score: 34, level: "C", comment: "高揚性は普通レベル。もっとワクワクに目を向けてみましょう！" },
    { min_score: 10, max_score: 24, level: "D", comment: "今は少し控えめかも？小さな楽しさから再起動を始めてみて！" }
  ]

  results.each do |r|
    Result.create!(r)
  end

  puts "🌱 Seed完了！設問と診断結果を登録しました。"
