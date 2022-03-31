class CreateRegionsPrefecturesMunicipalities < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.string :name, null: false

      t.timestamps
    end

    create_table :prefectures do |t|
      t.string :name, null: false
      t.references :region

      t.timestamps
    end

    create_table :municipalities do |t|
      t.string :name, null: false
      t.references :prefecture

      t.timestamps
    end
  end
end
