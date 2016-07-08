class CreateInterleaveDatapointDefaultValues < ActiveRecord::Migration
  def change
    create_table :interleave_datapoint_default_values do |t|
      t.integer  :interleave_datapoint_id,    null: false
      t.string   :column,                     null: false
      t.decimal  :default_value_as_number,          null: true
      t.string   :default_value_as_string,          null: true
      t.integer  :default_value_as_concept_id,      null: true
      t.boolean  :hardcoded,                  null: true
      t.timestamps null: false
    end
  end
end
