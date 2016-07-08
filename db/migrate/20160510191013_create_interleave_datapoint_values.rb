class CreateInterleaveDatapointValues < ActiveRecord::Migration
  def change
    create_table :interleave_datapoint_values do |t|
      t.integer   :interleave_datapoint_id,   null: false
      t.string    :column,                    null: false
      t.decimal   :value_as_number,           null: true
      t.string    :value_as_string,           null: true
      t.integer   :value_as_concept_id,       null: true
      t.timestamps                            null: false
    end
  end
end
