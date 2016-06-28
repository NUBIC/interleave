class CreateInterleaveDatapointConcepts < ActiveRecord::Migration
  def change
    create_table :interleave_datapoint_concepts do |t|
      t.integer   :interleave_datapoint_id, null: false
      t.string    :column,                  null: false
      t.integer   :concept_id, null: false
      t.timestamps null: false
    end
  end
end
