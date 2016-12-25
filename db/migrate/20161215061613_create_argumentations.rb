class CreateArgumentations < ActiveRecord::Migration[5.0]
  def change
    create_table :argumentations do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :main, default: nil
      t.belongs_to :argument, index: true

      t.timestamps
    end
  end
end
