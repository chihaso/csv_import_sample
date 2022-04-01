class CreatePopulations < ActiveRecord::Migration[7.0]
  def change
    create_table :populations do |t|
      t.integer :year, null: false
      t.integer :value, null: false
      t.references :municipality

      t.timestamps
    end
  end
end
