class CreateInterleaveRegistryCdmSources < ActiveRecord::Migration
  def change
    create_table :interleave_registry_cdm_sources do |t|
      t.integer   :interleave_registry_id,  null: false
      t.string    :cdm_source_name,         null: false
      t.timestamps null: false
    end
  end
end