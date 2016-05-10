class CreateInterleaveDatapointDomainConcepts < ActiveRecord::Migration
  def change
    create_table :interleave_datapoint_domain_concepts do |t|
      t.integer   :interleave_datapoint_id, null: false
      t.integer   :domain_concept_id, null: false
      t.timestamps null: false
    end
  end
end
