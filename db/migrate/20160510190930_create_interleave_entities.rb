class CreateInterleaveEntities < ActiveRecord::Migration
  def change
    create_table :interleave_entities do |t|
      t.integer   :interleave_datapoint_id, null: false
      t.string    :cdm_table, null: false
      t.integer   :domain_concept_id, null: false
      t.integer   :fact_id, null: false
      t.integer   :interleave_registry_cdm_source_id, null: false
      t.string    :domain_concept_source_value, null: true
      t.string    :fact_source_value, null: true
      t.datetime  :overriden_date, null: true
      t.integer   :overriden_interleave_registry_user_id, null: true
      t.timestamps null: false
    end
  end
end