class CreateResults < ActiveRecord::Migration[8.0]
  def change
    create_table :results do |t|
      t.integer :min_score, null: false
      t.integer :max_score, null: false
      t.string  :level,     null: false
      t.text    :comment,   null: false
      t.timestamps
    end
  end
end
