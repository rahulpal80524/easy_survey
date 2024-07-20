class CreateComponents < ActiveRecord::Migration[7.0]
  def change
    create_table :components do |t|
      t.references :survey, null: false, foreign_key: true
      t.json :component_details        

      t.timestamps
    end
  end
end
