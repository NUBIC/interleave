class CreateOmopClinicalDataTables < ActiveRecord::Migration
  def up
    create_table "condition_occurrence", id: false, force: :cascade do |t|
      t.primary_key "condition_occurrence_id"
      t.integer "person_id",                              null: false
      t.integer "condition_concept_id",                   null: false
      t.date    "condition_start_date",                   null: false
      t.date    "condition_end_date"
      t.integer "condition_type_concept_id",              null: false
      t.string  "stop_reason",                 limit: 20
      t.integer "provider_id"
      t.integer "visit_occurrence_id"
      t.string  "condition_source_value",      limit: 50
      t.integer "condition_source_concept_id"
      t.timestamps                             null: false
    end

    create_table "death", id: false, force: :cascade do |t|
      t.primary_key  "death_id"                       #Add
      t.integer "person_id",                          null: false
      t.date    "death_date",                         null: false
      t.integer "death_type_concept_id",              null: false
      t.integer "cause_concept_id"
      t.string  "cause_source_value",      limit: 50
      t.integer "cause_source_concept_id"
      t.timestamps                             null: false
    end

    create_table "drug_exposure", id: false, force: :cascade do |t|
      t.primary_key "drug_exposure_id"
      t.integer "person_id",                           null: false
      t.integer "drug_concept_id",                     null: false
      t.date    "drug_exposure_start_date",            null: false
      t.date    "drug_exposure_end_date"
      t.integer "drug_type_concept_id",                null: false
      t.string  "stop_reason",              limit: 20
      t.integer "refills"
      t.decimal "quantity"
      t.integer "days_supply"
      t.text    "sig"
      t.integer "route_concept_id"
      t.decimal "effective_drug_dose"
      t.integer "dose_unit_concept_id"
      t.string  "lot_number",               limit: 50
      t.integer "provider_id"
      t.integer "visit_occurrence_id"
      t.string  "drug_source_value",        limit: 50
      t.integer "drug_source_concept_id"
      t.string  "route_source_value",       limit: 50
      t.string  "dose_unit_source_value",   limit: 50
      t.timestamps                             null: false
    end

    create_table "fact_relationship", id: false, force: :cascade do |t|
      t.primary_key "fact_relationship_id"
      t.integer "domain_concept_id_1",     null: false
      t.integer "fact_id_1",               null: false
      t.integer "domain_concept_id_2",     null: false
      t.integer "fact_id_2",               null: false
      t.integer "relationship_concept_id", null: false
      t.timestamps                             null: false
    end

    create_table "measurement", id: false, force: :cascade do |t|
      t.primary_key "measurement_id"
      t.integer "person_id",                                null: false
      t.integer "measurement_concept_id",                   null: false
      t.date    "measurement_date",                         null: false
      t.string  "measurement_time",              limit: 10
      t.integer "measurement_type_concept_id",              null: false
      t.integer "operator_concept_id"
      t.decimal "value_as_number"
      t.integer "value_as_concept_id"
      t.integer "unit_concept_id"
      t.decimal "range_low"
      t.decimal "range_high"
      t.integer "provider_id"
      t.integer "visit_occurrence_id"
      t.string  "measurement_source_value",      limit: 50
      t.integer "measurement_source_concept_id"
      t.string  "unit_source_value",             limit: 50
      t.string  "value_source_value",            limit: 50
      t.timestamps                             null: false
    end

    create_table "note", id: false, force: :cascade do |t|
      t.primary_key "note_id"
      t.integer "person_id",                       null: false
      t.date    "note_date",                       null: false
      t.string  "note_time",            limit: 10
      t.integer "note_type_concept_id",            null: false
      t.text    "note_text",                       null: false
      t.integer "provider_id"
      t.integer "visit_occurrence_id"
      t.string  "note_source_value",    limit: 50
      t.timestamps                             null: false
    end

    create_table "observation", id: false, force: :cascade do |t|
      t.primary_key "observation_id"
      t.integer "person_id",                                null: false
      t.integer "observation_concept_id",                   null: false
      t.date    "observation_date",                         null: false
      t.string  "observation_time",              limit: 10
      t.integer "observation_type_concept_id",              null: false
      t.decimal "value_as_number"
      t.string  "value_as_string",               limit: 60
      t.integer "value_as_concept_id"
      t.integer "qualifier_concept_id"
      t.integer "unit_concept_id"
      t.integer "provider_id"
      t.integer "visit_occurrence_id"
      t.string  "observation_source_value",      limit: 50
      t.integer "observation_source_concept_id"
      t.string  "unit_source_value",             limit: 50
      t.string  "qualifier_source_value",        limit: 50
      t.timestamps                             null: false
    end

    create_table "observation_period", id: false do |t|
      t.primary_key   "observation_period_id"
      t.integer "person_id",                     null: false
      t.date    "observation_period_start_date", null: false
      t.date    "observation_period_end_date",   null: false
      t.integer "period_type_concept_id",        null: false
      t.timestamps                               null: false
    end

    create_table "person", id: false do |t|
      t.primary_key   "person_id"
      t.integer "gender_concept_id",                      null: false
      t.integer "year_of_birth",                          null: false
      t.integer "month_of_birth"
      t.integer "day_of_birth"
      t.string  "time_of_birth",               limit: 10
      t.integer "race_concept_id",                        null: false
      t.integer "ethnicity_concept_id",                   null: false
      t.integer "location_id"
      t.integer "provider_id"
      t.integer "care_site_id"
      t.string  "person_source_value",         limit: 50
      t.string  "gender_source_value",         limit: 50
      t.integer "gender_source_concept_id"
      t.string  "race_source_value",           limit: 50
      t.integer "race_source_concept_id"
      t.string  "ethnicity_source_value",      limit: 50
      t.integer "ethnicity_source_concept_id"
      t.timestamps                                  null: false
    end

    create_table "procedure_occurrence", id: false, force: :cascade do |t|
      t.primary_key "procedure_occurrence_id"
      t.integer "person_id",                              null: false
      t.integer "procedure_concept_id",                   null: false
      t.date    "procedure_date",                         null: false
      t.integer "procedure_type_concept_id",              null: false
      t.integer "modifier_concept_id"
      t.integer "quantity"
      t.integer "provider_id"
      t.integer "visit_occurrence_id"
      t.string  "procedure_source_value",      limit: 50
      t.integer "procedure_source_concept_id"
      t.string  "qualifier_source_value",      limit: 50
      t.timestamps                             null: false
    end

    create_table "specimen", id: false do |t|
      t.primary_key  "specimen_id"
      t.integer "person_id",                              null: false
      t.integer "specimen_concept_id",                    null: false
      t.integer "specimen_type_concept_id",               null: false
      t.date    "specimen_date",                          null: false
      t.string  "specimen_time",               limit: 10
      t.decimal "quantity"
      t.integer "unit_concept_id"
      t.integer "anatomic_site_concept_id"
      t.integer "disease_status_concept_id"
      t.string  "specimen_source_id",          limit: 50
      t.string  "specimen_source_value",       limit: 50
      t.string  "unit_source_value",           limit: 50
      t.string  "anatomic_site_source_value",  limit: 50
      t.string  "disease_status_source_value", limit: 50
      t.timestamps                             null: false
    end

    create_table "visit_occurrence", id: false, force: :cascade do |t|
      t.primary_key  "visit_occurrence_id"
      t.integer "person_id",                          null: false
      t.integer "visit_concept_id",                   null: false
      t.date    "visit_start_date",                   null: false
      t.string  "visit_start_time",        limit: 10
      t.date    "visit_end_date",                     null: false
      t.string  "visit_end_time",          limit: 10
      t.integer "visit_type_concept_id",              null: false
      t.integer "provider_id"
      t.integer "care_site_id"
      t.string  "visit_source_value",      limit: 50
      t.integer "visit_source_concept_id"
      t.timestamps                             null: false
    end
  end

  def down
    drop_table :condition_occurrence
    drop_table :death
    drop_table :drug_exposure
    drop_table :fact_relationship
    drop_table :measurement
    drop_table :note
    drop_table :observation
    drop_table :observation_period
    drop_table :person
    drop_table :procedure_occurence
    drop_table :specimen
    drop_table :visit_occurrence
  end
end