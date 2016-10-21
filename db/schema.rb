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

ActiveRecord::Schema.define(version: 20160628195204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attribute_definition", id: false, force: :cascade do |t|
    t.integer "attribute_definition_id",               null: false
    t.string  "attribute_name",            limit: 255, null: false
    t.text    "attribute_description"
    t.integer "attribute_type_concept_id",             null: false
    t.text    "attribute_syntax"
  end

  add_index "attribute_definition", ["attribute_definition_id"], name: "idx_attribute_definition_id", using: :btree

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

  add_index "cohort", ["cohort_definition_id"], name: "idx_cohort_c_definition_id", using: :btree
  add_index "cohort", ["subject_id"], name: "idx_cohort_subject_id", using: :btree

  create_table "cohort_attribute", id: false, force: :cascade do |t|
    t.integer "cohort_definition_id",    null: false
    t.date    "cohort_start_date",       null: false
    t.date    "cohort_end_date",         null: false
    t.integer "subject_id",              null: false
    t.integer "attribute_definition_id", null: false
    t.decimal "value_as_number"
    t.integer "value_as_concept_id"
  end

  add_index "cohort_attribute", ["cohort_definition_id"], name: "idx_ca_definition_id", using: :btree
  add_index "cohort_attribute", ["subject_id"], name: "idx_ca_subject_id", using: :btree

  create_table "cohort_definition", id: false, force: :cascade do |t|
    t.integer "cohort_definition_id",                      null: false
    t.string  "cohort_definition_name",        limit: 255, null: false
    t.text    "cohort_definition_description"
    t.integer "definition_type_concept_id",                null: false
    t.text    "cohort_definition_syntax"
    t.integer "subject_concept_id",                        null: false
    t.date    "cohort_initiation_date"
  end

  add_index "cohort_definition", ["cohort_definition_id"], name: "idx_cohort_definition_id", using: :btree

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

  add_index "concept", ["concept_class_id"], name: "idx_concept_class_id", using: :btree
  add_index "concept", ["concept_code"], name: "idx_concept_code", using: :btree
  add_index "concept", ["concept_id"], name: "idx_concept_concept_id", unique: true, using: :btree
  add_index "concept", ["domain_id"], name: "idx_concept_domain_id", using: :btree
  add_index "concept", ["vocabulary_id"], name: "idx_concept_vocabluary_id", using: :btree

  create_table "concept_ancestor", id: false, force: :cascade do |t|
    t.integer "ancestor_concept_id",      null: false
    t.integer "descendant_concept_id",    null: false
    t.integer "min_levels_of_separation", null: false
    t.integer "max_levels_of_separation", null: false
  end

  add_index "concept_ancestor", ["ancestor_concept_id"], name: "idx_concept_ancestor_id_1", using: :btree
  add_index "concept_ancestor", ["descendant_concept_id"], name: "idx_concept_ancestor_id_2", using: :btree

  create_table "concept_class", id: false, force: :cascade do |t|
    t.string  "concept_class_id",         limit: 20,  null: false
    t.string  "concept_class_name",       limit: 255, null: false
    t.integer "concept_class_concept_id",             null: false
  end

  add_index "concept_class", ["concept_class_id"], name: "idx_concept_class_class_id", unique: true, using: :btree

  create_table "concept_relationship", id: false, force: :cascade do |t|
    t.integer "concept_id_1",                null: false
    t.integer "concept_id_2",                null: false
    t.string  "relationship_id",  limit: 20, null: false
    t.date    "valid_start_date",            null: false
    t.date    "valid_end_date",              null: false
    t.string  "invalid_reason",   limit: 1
  end

  add_index "concept_relationship", ["concept_id_1"], name: "idx_concept_relationship_id_1", using: :btree
  add_index "concept_relationship", ["concept_id_2"], name: "idx_concept_relationship_id_2", using: :btree
  add_index "concept_relationship", ["relationship_id"], name: "idx_concept_relationship_id_3", using: :btree

  create_table "concept_synonym", id: false, force: :cascade do |t|
    t.integer "concept_id",                        null: false
    t.string  "concept_synonym_name", limit: 1000, null: false
    t.integer "language_concept_id",               null: false
  end

  add_index "concept_synonym", ["concept_id"], name: "idx_concept_synonym_id", using: :btree

  create_table "condition_era", id: false, force: :cascade do |t|
    t.integer "condition_era_id",           null: false
    t.integer "person_id",                  null: false
    t.integer "condition_concept_id",       null: false
    t.date    "condition_era_start_date",   null: false
    t.date    "condition_era_end_date",     null: false
    t.integer "condition_occurrence_count"
  end

  add_index "condition_era", ["condition_concept_id"], name: "idx_condition_era_concept_id", using: :btree
  add_index "condition_era", ["person_id"], name: "idx_condition_era_person_id", using: :btree

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

  add_index "condition_occurrence", ["condition_concept_id"], name: "idx_condition_concept_id", using: :btree
  add_index "condition_occurrence", ["person_id"], name: "idx_condition_person_id", using: :btree
  add_index "condition_occurrence", ["visit_occurrence_id"], name: "idx_condition_visit_id", using: :btree

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

  add_index "death", ["person_id"], name: "idx_death_person_id", using: :btree

  create_table "device_exposure", primary_key: "device_exposure_id", force: :cascade do |t|
    t.integer  "person_id",                              null: false
    t.integer  "device_concept_id",                      null: false
    t.date     "device_exposure_start_date",             null: false
    t.date     "device_exposure_end_date"
    t.integer  "device_type_concept_id",                 null: false
    t.string   "unique_device_id",           limit: 50
    t.integer  "quantity"
    t.integer  "provider_id"
    t.integer  "visit_occurrence_id"
    t.string   "device_source_value",        limit: 100
    t.integer  "device_source_concept_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "device_exposure", ["device_concept_id"], name: "idx_device_concept_id", using: :btree
  add_index "device_exposure", ["person_id"], name: "idx_device_person_id", using: :btree
  add_index "device_exposure", ["visit_occurrence_id"], name: "idx_device_visit_id", using: :btree

  create_table "domain", id: false, force: :cascade do |t|
    t.string  "domain_id",         limit: 20,  null: false
    t.string  "domain_name",       limit: 255, null: false
    t.integer "domain_concept_id",             null: false
  end

  add_index "domain", ["domain_id"], name: "idx_domain_domain_id", unique: true, using: :btree

  create_table "dose_era", id: false, force: :cascade do |t|
    t.integer "dose_era_id",         null: false
    t.integer "person_id",           null: false
    t.integer "drug_concept_id",     null: false
    t.integer "unit_concept_id",     null: false
    t.decimal "dose_value",          null: false
    t.date    "dose_era_start_date", null: false
    t.date    "dose_era_end_date",   null: false
  end

  add_index "dose_era", ["drug_concept_id"], name: "idx_dose_era_concept_id", using: :btree
  add_index "dose_era", ["person_id"], name: "idx_dose_era_person_id", using: :btree

  create_table "drug_era", id: false, force: :cascade do |t|
    t.integer "drug_era_id",         null: false
    t.integer "person_id",           null: false
    t.integer "drug_concept_id",     null: false
    t.date    "drug_era_start_date", null: false
    t.date    "drug_era_end_date",   null: false
    t.integer "drug_exposure_count"
    t.integer "gap_days"
  end

  add_index "drug_era", ["drug_concept_id"], name: "idx_drug_era_concept_id", using: :btree
  add_index "drug_era", ["person_id"], name: "idx_drug_era_person_id", using: :btree

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

  add_index "drug_exposure", ["drug_concept_id"], name: "idx_drug_concept_id", using: :btree
  add_index "drug_exposure", ["person_id"], name: "idx_drug_person_id", using: :btree
  add_index "drug_exposure", ["visit_occurrence_id"], name: "idx_drug_visit_id", using: :btree

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

  add_index "drug_strength", ["drug_concept_id"], name: "idx_drug_strength_id_1", using: :btree
  add_index "drug_strength", ["ingredient_concept_id"], name: "idx_drug_strength_id_2", using: :btree

  create_table "fact_relationship", primary_key: "fact_relationship_id", force: :cascade do |t|
    t.integer  "domain_concept_id_1",     null: false
    t.integer  "fact_id_1",               null: false
    t.integer  "domain_concept_id_2",     null: false
    t.integer  "fact_id_2",               null: false
    t.integer  "relationship_concept_id", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "fact_relationship", ["domain_concept_id_1"], name: "idx_fact_relationship_id_1", using: :btree
  add_index "fact_relationship", ["domain_concept_id_2"], name: "idx_fact_relationship_id_2", using: :btree
  add_index "fact_relationship", ["relationship_concept_id"], name: "idx_fact_relationship_id_3", using: :btree

  create_table "interleave_datapoint_default_values", force: :cascade do |t|
    t.integer  "interleave_datapoint_id",     null: false
    t.string   "column",                      null: false
    t.decimal  "default_value_as_number"
    t.string   "default_value_as_string"
    t.integer  "default_value_as_concept_id"
    t.boolean  "hardcoded"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "interleave_datapoint_relationships", force: :cascade do |t|
    t.integer  "interleave_datapoint_id",     null: false
    t.integer  "interleave_sub_datapoint_id", null: false
    t.integer  "relationship_concept_id",     null: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "interleave_datapoint_values", force: :cascade do |t|
    t.integer  "interleave_datapoint_id", null: false
    t.string   "column",                  null: false
    t.decimal  "value_as_number"
    t.string   "value_as_string"
    t.integer  "value_as_concept_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "interleave_datapoints", force: :cascade do |t|
    t.integer  "interleave_registry_id", null: false
    t.string   "group_name"
    t.string   "name",                   null: false
    t.string   "domain_id",              null: false
    t.integer  "cardinality",            null: false
    t.boolean  "overlap",                null: false
    t.string   "value_type"
    t.decimal  "range_low"
    t.decimal  "range_high"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "interleave_entities", force: :cascade do |t|
    t.integer  "interleave_datapoint_id",               null: false
    t.integer  "parent_id"
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
    t.integer  "interleave_person_id",           null: false
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

  add_index "measurement", ["measurement_concept_id"], name: "idx_measurement_concept_id", using: :btree
  add_index "measurement", ["person_id"], name: "idx_measurement_person_id", using: :btree
  add_index "measurement", ["visit_occurrence_id"], name: "idx_measurement_visit_id", using: :btree

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

  add_index "note", ["note_type_concept_id"], name: "idx_note_concept_id", using: :btree
  add_index "note", ["person_id"], name: "idx_note_person_id", using: :btree
  add_index "note", ["visit_occurrence_id"], name: "idx_note_visit_id", using: :btree

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

  add_index "observation", ["observation_concept_id"], name: "idx_observation_concept_id", using: :btree
  add_index "observation", ["person_id"], name: "idx_observation_person_id", using: :btree
  add_index "observation", ["visit_occurrence_id"], name: "idx_observation_visit_id", using: :btree

  create_table "observation_period", primary_key: "observation_period_id", force: :cascade do |t|
    t.integer  "person_id",                     null: false
    t.date     "observation_period_start_date", null: false
    t.date     "observation_period_end_date",   null: false
    t.integer  "period_type_concept_id",        null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  add_index "observation_period", ["person_id"], name: "idx_observation_period_id", using: :btree

  create_table "payer_plan_period", id: false, force: :cascade do |t|
    t.integer "payer_plan_period_id",                    null: false
    t.integer "person_id",                               null: false
    t.date    "payer_plan_period_start_date",            null: false
    t.date    "payer_plan_period_end_date",              null: false
    t.string  "payer_source_value",           limit: 50
    t.string  "plan_source_value",            limit: 50
    t.string  "family_source_value",          limit: 50
  end

  add_index "payer_plan_period", ["person_id"], name: "idx_period_person_id", using: :btree

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

  add_index "person", ["person_id"], name: "idx_person_id", unique: true, using: :btree

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

  add_index "procedure_occurrence", ["person_id"], name: "idx_procedure_person_id", using: :btree
  add_index "procedure_occurrence", ["procedure_concept_id"], name: "idx_procedure_concept_id", using: :btree
  add_index "procedure_occurrence", ["visit_occurrence_id"], name: "idx_procedure_visit_id", using: :btree

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

  add_index "relationship", ["relationship_id"], name: "idx_relationship_rel_id", unique: true, using: :btree

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

  add_index "source_to_concept_map", ["source_code"], name: "idx_source_to_concept_map_code", using: :btree
  add_index "source_to_concept_map", ["source_vocabulary_id"], name: "idx_source_to_concept_map_id_1", using: :btree
  add_index "source_to_concept_map", ["target_concept_id"], name: "idx_source_to_concept_map_id_3", using: :btree
  add_index "source_to_concept_map", ["target_vocabulary_id"], name: "idx_source_to_concept_map_id_2", using: :btree

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

  add_index "specimen", ["person_id"], name: "idx_specimen_person_id", using: :btree
  add_index "specimen", ["specimen_concept_id"], name: "idx_specimen_concept_id", using: :btree

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

  add_index "visit_occurrence", ["person_id"], name: "idx_visit_person_id", using: :btree
  add_index "visit_occurrence", ["visit_concept_id"], name: "idx_visit_concept_id", using: :btree

  create_table "vocabulary", id: false, force: :cascade do |t|
    t.string  "vocabulary_id",         limit: 20,  null: false
    t.string  "vocabulary_name",       limit: 255, null: false
    t.string  "vocabulary_reference",  limit: 255
    t.string  "vocabulary_version",    limit: 255
    t.integer "vocabulary_concept_id",             null: false
  end

  add_index "vocabulary", ["vocabulary_id"], name: "idx_vocabulary_vocabulary_id", unique: true, using: :btree

end
