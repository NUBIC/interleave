# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160510225153) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attribute_definition", id: false, force: :cascade do |t|
    t.integer "attribute_definition_id",               null: false
    t.string  "attribute_name",            limit: 255, null: false
    t.text    "attribute_description"
    t.integer "attribute_type_concept_id",             null: false
    t.text    "attribute_syntax"
  end

  create_table "care_site", id: false, force: :cascade do |t|
    t.integer "care_site_id",                              null: false
    t.string  "care_site_name",                limit: 255
    t.integer "place_of_service_concept_id"
    t.integer "location_id"
    t.string  "care_site_source_value",        limit: 50
    t.string  "place_of_service_source_value", limit: 50
  end

  create_table "cdm_source", id: false, force: :cascade do |t|
    t.string "cdm_source_name",                limit: 255, null: false
    t.string "cdm_source_abbreviation",        limit: 25
    t.string "cdm_holder",                     limit: 255
    t.text   "source_description"
    t.string "source_documentation_reference", limit: 255
    t.string "cdm_etl_reference",              limit: 255
    t.date   "source_release_date"
    t.date   "cdm_release_date"
    t.string "cdm_version",                    limit: 10
    t.string "vocabulary_version",             limit: 20
  end

  create_table "cohort", id: false, force: :cascade do |t|
    t.integer "cohort_definition_id", null: false
    t.integer "subject_id",           null: false
    t.date    "cohort_start_date",    null: false
    t.date    "cohort_end_date",      null: false
  end

  create_table "cohort_attribute", id: false, force: :cascade do |t|
    t.integer "cohort_definition_id",    null: false
    t.date    "cohort_start_date",       null: false
    t.date    "cohort_end_date",         null: false
    t.integer "subject_id",              null: false
    t.integer "attribute_definition_id", null: false
    t.decimal "value_as_number"
    t.integer "value_as_concept_id"
  end

  create_table "cohort_definition", id: false, force: :cascade do |t|
    t.integer "cohort_definition_id",                      null: false
    t.string  "cohort_definition_name",        limit: 255, null: false
    t.text    "cohort_definition_description"
    t.integer "definition_type_concept_id",                null: false
    t.text    "cohort_definition_syntax"
    t.integer "subject_concept_id",                        null: false
    t.date    "cohort_initiation_date"
  end

  create_table "concept", id: false, force: :cascade do |t|
    t.integer "concept_id",                   null: false
    t.string  "concept_name",     limit: 255, null: false
    t.string  "domain_id",        limit: 20,  null: false
    t.string  "vocabulary_id",    limit: 20,  null: false
    t.string  "concept_class_id", limit: 20,  null: false
    t.string  "standard_concept", limit: 1
    t.string  "concept_code",     limit: 50,  null: false
    t.date    "valid_start_date",             null: false
    t.date    "valid_end_date",               null: false
    t.string  "invalid_reason",   limit: 1
  end

  create_table "concept_ancestor", id: false, force: :cascade do |t|
    t.integer "ancestor_concept_id",      null: false
    t.integer "descendant_concept_id",    null: false
    t.integer "min_levels_of_separation", null: false
    t.integer "max_levels_of_separation", null: false
  end

  create_table "concept_class", id: false, force: :cascade do |t|
    t.string  "concept_class_id",         limit: 20,  null: false
    t.string  "concept_class_name",       limit: 255, null: false
    t.integer "concept_class_concept_id",             null: false
  end

  create_table "concept_relationship", id: false, force: :cascade do |t|
    t.integer "concept_id_1",                null: false
    t.integer "concept_id_2",                null: false
    t.string  "relationship_id",  limit: 20, null: false
    t.date    "valid_start_date",            null: false
    t.date    "valid_end_date",              null: false
    t.string  "invalid_reason",   limit: 1
  end

  create_table "concept_synonym", id: false, force: :cascade do |t|
    t.integer "concept_id",                        null: false
    t.string  "concept_synonym_name", limit: 1000, null: false
    t.integer "language_concept_id",               null: false
  end

  create_table "condition_era", id: false, force: :cascade do |t|
    t.integer "condition_era_id",           null: false
    t.integer "person_id",                  null: false
    t.integer "condition_concept_id",       null: false
    t.date    "condition_era_start_date",   null: false
    t.date    "condition_era_end_date",     null: false
    t.integer "condition_occurrence_count"
  end

  create_table "condition_occurrence", primary_key: "condition_occurrence_id", force: :cascade do |t|
    t.integer  "person_id",                              null: false
    t.integer  "condition_concept_id",                   null: false
    t.date     "condition_start_date",                   null: false
    t.date     "condition_end_date"
    t.integer  "condition_type_concept_id",              null: false
    t.string   "stop_reason",                 limit: 20
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "condition_source_value",      limit: 50
    t.integer  "condition_source_concept_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "cost", id: false, force: :cascade do |t|
    t.integer "cost_id",                             null: false
    t.integer "cost_event_id",                       null: false
    t.string  "cost_domain_id",           limit: 20, null: false
    t.integer "cost_type_concept_id",                null: false
    t.integer "currency_concept_id"
    t.decimal "total_charge"
    t.decimal "total_cost"
    t.decimal "total_paid"
    t.decimal "paid_by_payer"
    t.decimal "paid_by_patient"
    t.decimal "paid_patient_copay"
    t.decimal "paid_patient_coinsurance"
    t.decimal "paid_patient_deductible"
    t.decimal "paid_by_primary"
    t.decimal "paid_ingredient_cost"
    t.decimal "paid_dispensing_fee"
    t.integer "payer_plan_period_id"
    t.decimal "amount_allowed"
    t.integer "revenue_code_concept_id"
    t.string  "reveue_code_source_value", limit: 50
  end

  create_table "death", primary_key: "death_id", force: :cascade do |t|
    t.integer  "person_id",                          null: false
    t.date     "death_date",                         null: false
    t.integer  "death_type_concept_id",              null: false
    t.integer  "cause_concept_id"
    t.string   "cause_source_value",      limit: 50
    t.integer  "cause_source_concept_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "domain", id: false, force: :cascade do |t|
    t.string  "domain_id",         limit: 20,  null: false
    t.string  "domain_name",       limit: 255, null: false
    t.integer "domain_concept_id",             null: false
  end

  create_table "dose_era", id: false, force: :cascade do |t|
    t.integer "dose_era_id",         null: false
    t.integer "person_id",           null: false
    t.integer "drug_concept_id",     null: false
    t.integer "unit_concept_id",     null: false
    t.decimal "dose_value",          null: false
    t.date    "dose_era_start_date", null: false
    t.date    "dose_era_end_date",   null: false
  end

  create_table "drug_era", id: false, force: :cascade do |t|
    t.integer "drug_era_id",         null: false
    t.integer "person_id",           null: false
    t.integer "drug_concept_id",     null: false
    t.date    "drug_era_start_date", null: false
    t.date    "drug_era_end_date",   null: false
    t.integer "drug_exposure_count"
    t.integer "gap_days"
  end

  create_table "drug_exposure", primary_key: "drug_exposure_id", force: :cascade do |t|
    t.integer  "person_id",                           null: false
    t.integer  "drug_concept_id",                     null: false
    t.date     "drug_exposure_start_date",            null: false
    t.date     "drug_exposure_end_date"
    t.integer  "drug_type_concept_id",                null: false
    t.string   "stop_reason",              limit: 20
    t.integer  "refills"
    t.decimal  "quantity"
    t.integer  "days_supply"
    t.text     "sig"
    t.integer  "route_concept_id"
    t.decimal  "effective_drug_dose"
    t.integer  "dose_unit_concept_id"
    t.string   "lot_number",               limit: 50
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "drug_source_value",        limit: 50
    t.integer  "drug_source_concept_id"
    t.string   "route_source_value",       limit: 50
    t.string   "dose_unit_source_value",   limit: 50
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "drug_strength", id: false, force: :cascade do |t|
    t.integer "drug_concept_id",                       null: false
    t.integer "ingredient_concept_id",                 null: false
    t.decimal "amount_value"
    t.integer "amount_unit_concept_id"
    t.decimal "numerator_value"
    t.integer "numerator_unit_concept_id"
    t.decimal "denominator_value"
    t.integer "denominator_unit_concept_id"
    t.date    "valid_start_date",                      null: false
    t.date    "valid_end_date",                        null: false
    t.string  "invalid_reason",              limit: 1
  end

  create_table "fact_relationship", primary_key: "fact_relationship_id", force: :cascade do |t|
    t.integer  "domain_concept_id_1",     null: false
    t.integer  "fact_id_1",               null: false
    t.integer  "domain_concept_id_2",     null: false
    t.integer  "fact_id_2",               null: false
    t.integer  "relationship_concept_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "interleave_datapoint_domain_concepts", force: :cascade do |t|
    t.integer  "interleave_datapoint_id", null: false
    t.integer  "domain_concept_id",       null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "interleave_datapoint_relationships", force: :cascade do |t|
    t.integer  "interleave_datapoint_id", null: false
    t.integer  "domain_concept_id",       null: false
    t.integer  "relationship_concept_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "interleave_datapoints", force: :cascade do |t|
    t.integer  "interleave_registry_id", null: false
    t.string   "name",                   null: false
    t.string   "domain_id",              null: false
    t.integer  "cardinality",            null: false
    t.boolean  "unrestricted",           null: false
    t.boolean  "overlap",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "interleave_entities", force: :cascade do |t|
    t.integer  "interleave_datapoint_id",               null: false
    t.string   "cdm_table",                             null: false
    t.integer  "domain_concept_id",                     null: false
    t.integer  "fact_id",                               null: false
    t.integer  "interleave_registry_cdm_source_id",     null: false
    t.string   "domain_concept_source_value"
    t.string   "fact_source_value"
    t.datetime "overriden_date"
    t.integer  "overriden_interleave_registry_user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "interleave_people", force: :cascade do |t|
    t.integer  "interleave_registry_affiliate_id", null: false
    t.integer  "person_id",                        null: false
    t.string   "first_name",                       null: false
    t.string   "last_name",                        null: false
    t.string   "middle_name"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "interleave_person_identifiers", force: :cascade do |t|
    t.integer  "person_id",                      null: false
    t.string   "identifier",                     null: false
    t.integer  "identifier_concept_id",          null: false
    t.string   "identifer_source_concept_value", null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "interleave_registries", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "interleave_registry_affiliate_users", force: :cascade do |t|
    t.integer  "interleave_registry_affiliate_id", null: false
    t.integer  "interleave_user_id",               null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "interleave_registry_affiliates", force: :cascade do |t|
    t.string   "name",                   null: false
    t.integer  "interleave_registry_id", null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "interleave_registry_cdm_sources", force: :cascade do |t|
    t.integer  "interleave_registry_id", null: false
    t.string   "cdm_source_name",        null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "interleave_users", force: :cascade do |t|
    t.string   "first_name",  null: false
    t.string   "last_name",   null: false
    t.string   "middle_name", null: false
    t.string   "username",    null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "location", id: false, force: :cascade do |t|
    t.integer "location_id",                      null: false
    t.string  "address_1",             limit: 50
    t.string  "address_2",             limit: 50
    t.string  "city",                  limit: 50
    t.string  "state",                 limit: 2
    t.string  "zip",                   limit: 9
    t.string  "county",                limit: 20
    t.string  "location_source_value", limit: 50
  end

  create_table "measurement", primary_key: "measurement_id", force: :cascade do |t|
    t.integer  "person_id",                                null: false
    t.integer  "measurement_concept_id",                   null: false
    t.date     "measurement_date",                         null: false
    t.string   "measurement_time",              limit: 10
    t.integer  "measurement_type_concept_id",              null: false
    t.integer  "operator_concept_id"
    t.decimal  "value_as_number"
    t.integer  "value_as_concept_id"
    t.integer  "unit_concept_id"
    t.decimal  "range_low"
    t.decimal  "range_high"
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "measurement_source_value",      limit: 50
    t.integer  "measurement_source_concept_id"
    t.string   "unit_source_value",             limit: 50
    t.string   "value_source_value",            limit: 50
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "note", primary_key: "note_id", force: :cascade do |t|
    t.integer  "person_id",                       null: false
    t.date     "note_date",                       null: false
    t.string   "note_time",            limit: 10
    t.integer  "note_type_concept_id",            null: false
    t.text     "note_text",                       null: false
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "note_source_value",    limit: 50
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "observation", primary_key: "observation_id", force: :cascade do |t|
    t.integer  "person_id",                                null: false
    t.integer  "observation_concept_id",                   null: false
    t.date     "observation_date",                         null: false
    t.string   "observation_time",              limit: 10
    t.integer  "observation_type_concept_id",              null: false
    t.decimal  "value_as_number"
    t.string   "value_as_string",               limit: 60
    t.integer  "value_as_concept_id"
    t.integer  "qualifier_concept_id"
    t.integer  "unit_concept_id"
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "observation_source_value",      limit: 50
    t.integer  "observation_source_concept_id"
    t.string   "unit_source_value",             limit: 50
    t.string   "qualifier_source_value",        limit: 50
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "observation_period", primary_key: "observation_period_id", force: :cascade do |t|
    t.integer  "person_id",                     null: false
    t.date     "observation_period_start_date", null: false
    t.date     "observation_period_end_date",   null: false
    t.integer  "period_type_concept_id",        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "payer_plan_period", id: false, force: :cascade do |t|
    t.integer "payer_plan_period_id",                    null: false
    t.integer "person_id",                               null: false
    t.date    "payer_plan_period_start_date",            null: false
    t.date    "payer_plan_period_end_date",              null: false
    t.string  "payer_source_value",           limit: 50
    t.string  "plan_source_value",            limit: 50
    t.string  "family_source_value",          limit: 50
  end

  create_table "person", primary_key: "person_id", force: :cascade do |t|
    t.integer  "gender_concept_id",                      null: false
    t.integer  "year_of_birth",                          null: false
    t.integer  "month_of_birth"
    t.integer  "day_of_birth"
    t.string   "time_of_birth",               limit: 10
    t.integer  "race_concept_id",                        null: false
    t.integer  "ethnicity_concept_id",                   null: false
    t.integer  "location_id"
    t.integer  "provider_id"
    t.integer  "care_site_id"
    t.string   "person_source_value",         limit: 50
    t.string   "gender_source_value",         limit: 50
    t.integer  "gender_source_concept_id"
    t.string   "race_source_value",           limit: 50
    t.integer  "race_source_concept_id"
    t.string   "ethnicity_source_value",      limit: 50
    t.integer  "ethnicity_source_concept_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "procedure_occurrence", primary_key: "procedure_occurrence_id", force: :cascade do |t|
    t.integer  "person_id",                              null: false
    t.integer  "procedure_concept_id",                   null: false
    t.date     "procedure_date",                         null: false
    t.integer  "procedure_type_concept_id",              null: false
    t.integer  "modifier_concept_id"
    t.integer  "quantity"
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "procedure_source_value",      limit: 50
    t.integer  "procedure_source_concept_id"
    t.string   "qualifier_source_value",      limit: 50
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "provider", id: false, force: :cascade do |t|
    t.integer "provider_id",                             null: false
    t.string  "provider_name",               limit: 255
    t.string  "npi",                         limit: 20
    t.string  "dea",                         limit: 20
    t.integer "specialty_concept_id"
    t.integer "care_site_id"
    t.integer "year_of_birth"
    t.integer "gender_concept_id"
    t.string  "provider_source_value",       limit: 50
    t.string  "specialty_source_value",      limit: 50
    t.integer "specialty_source_concept_id"
    t.string  "gender_source_value",         limit: 50
    t.integer "gender_source_concept_id"
  end

  create_table "relationship", id: false, force: :cascade do |t|
    t.string  "relationship_id",         limit: 20,  null: false
    t.string  "relationship_name",       limit: 255, null: false
    t.string  "is_hierarchical",         limit: 1,   null: false
    t.string  "defines_ancestry",        limit: 1,   null: false
    t.string  "reverse_relationship_id", limit: 20,  null: false
    t.integer "relationship_concept_id",             null: false
  end

  create_table "source_to_concept_map", id: false, force: :cascade do |t|
    t.string  "source_code",             limit: 50,  null: false
    t.integer "source_concept_id",                   null: false
    t.string  "source_vocabulary_id",    limit: 20,  null: false
    t.string  "source_code_description", limit: 255
    t.integer "target_concept_id",                   null: false
    t.string  "target_vocabulary_id",    limit: 20,  null: false
    t.date    "valid_start_date",                    null: false
    t.date    "valid_end_date",                      null: false
    t.string  "invalid_reason",          limit: 1
  end

  create_table "specimen", primary_key: "specimen_id", force: :cascade do |t|
    t.integer  "person_id",                              null: false
    t.integer  "specimen_concept_id",                    null: false
    t.integer  "specimen_type_concept_id",               null: false
    t.date     "specimen_date",                          null: false
    t.string   "specimen_time",               limit: 10
    t.decimal  "quantity"
    t.integer  "unit_concept_id"
    t.integer  "anatomic_site_concept_id"
    t.integer  "disease_status_concept_id"
    t.string   "specimen_source_id",          limit: 50
    t.string   "specimen_source_value",       limit: 50
    t.string   "unit_source_value",           limit: 50
    t.string   "anatomic_site_source_value",  limit: 50
    t.string   "disease_status_source_value", limit: 50
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "visit_occurrence", primary_key: "visit_occurrence_id", force: :cascade do |t|
    t.integer  "person_id",                          null: false
    t.integer  "visit_concept_id",                   null: false
    t.date     "visit_start_date",                   null: false
    t.string   "visit_start_time",        limit: 10
    t.date     "visit_end_date",                     null: false
    t.string   "visit_end_time",          limit: 10
    t.integer  "visit_type_concept_id",              null: false
    t.integer  "provider_id"
    t.integer  "care_site_id"
    t.string   "visit_source_value",      limit: 50
    t.integer  "visit_source_concept_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  create_table "vocabulary", id: false, force: :cascade do |t|
    t.string  "vocabulary_id",         limit: 20,  null: false
    t.string  "vocabulary_name",       limit: 255, null: false
    t.string  "vocabulary_reference",  limit: 255
    t.string  "vocabulary_version",    limit: 255
    t.integer "vocabulary_concept_id",             null: false
  end

end
