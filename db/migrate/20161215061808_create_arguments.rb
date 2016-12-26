class CreateArguments < ActiveRecord::Migration[5.0]
  def change
    create_table :arguments do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :parent_argumentation_id
      t.belongs_to :argumentation, index: true
      t.integer :place, default: 0

      t.timestamps
    end
  end
end
