class CreateInterleavePersonIdentifiers < ActiveRecord::Migration
  def change
    create_table :interleave_person_identifiers do |t|
      t.integer   :interleave_person_id, null: false
      t.string    :identifier, null: false
      t.integer   :identifier_concept_id, null: false
      t.string    :identifer_source_concept_value, null: false
      t.timestamps null: false
    end
  end
end