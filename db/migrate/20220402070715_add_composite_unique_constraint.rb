class AddCompositeUniqueConstraint < ActiveRecord::Migration[7.0]
  def change
    add_index :populations, [:municipality_id, :year], unique: true
  end
end
