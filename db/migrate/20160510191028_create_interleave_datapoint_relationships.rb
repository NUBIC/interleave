class CreateInterleaveDatapointRelationships < ActiveRecord::Migration
  def change
    create_table :interleave_datapoint_relationships do |t|
      t.integer   :interleave_datapoint_id, null: false
      t.integer   :domain_concept_id, null: false      
      t.integer   :relationship_concept_id, null: false      
      t.timestamps null: false
    end
  end
end