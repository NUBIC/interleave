require 'rails_helper'
require 'active_support'

RSpec.describe DrugExposure, type: :model do
  it { should belong_to :drug_concept }
  it { should belong_to :drug_type_concept }
  it { should belong_to :person }
  it { should belong_to :route_concept }
  it { should belong_to :dose_unit_concept }

  it { should validate_presence_of :drug_concept_id }
  it { should validate_presence_of :drug_exposure_start_date }
  it { should validate_presence_of :drug_type_concept_id }

  before(:each) do
    interleave_spec_setup
    @person_little_my = FactoryGirl.create(:person, gender: @concept_gender_female, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @person_moomin = FactoryGirl.create(:person, gender: @concept_gender_male, race: @concept_race_asian, ethnicity: @concept_ethnicity_hispanic_or_latino)
    @interleave_registry = FactoryGirl.create(:interleave_registry, name: 'Prostate SPORE')
    @interleave_registry_affiliate = FactoryGirl.create(:interleave_registry_affiliate, name: 'Northwestern', interleave_registry: @interleave_registry)
    @interleave_registry_cdm_source = FactoryGirl.create(:interleave_registry_cdm_source, cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: @interleave_registry)
    @interleave_datapoint_drug = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Drugs', domain_id: DrugExposure::DOMAIN_ID, cardinality: 0, overlap: true)
    @interleave_datapoint_drug_2 = FactoryGirl.create(:interleave_datapoint, interleave_registry: @interleave_registry, name: 'Drugs', domain_id: DrugExposure::DOMAIN_ID, cardinality: 0, overlap: true)
  end

  it 'knows its domain concept', focus: false do
    expect(DrugExposure.domain_concept).to eq(@concept_domain_drug_exposure)
  end

  it 'creates an interleave entity upon save with sub datapoints', focus: false do
    durg_exposure_1 = FactoryGirl.build(:drug_exposure, person: @person_little_my, drug_concept: @concept_drug_carbidopa, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_drug.id)
    durg_exposure_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    expect(InterleaveEntity.where(interleave_datapoint_id: @interleave_datapoint_drug, cdm_table: DrugExposure.table_name, domain_concept_id: DrugExposure.domain_concept.id, fact_id: durg_exposure_1.id, interleave_registry_cdm_source_id: @interleave_registry_cdm_source).count).to eq(1)
  end

  it 'reports drug exposures by person', focus: false do
    durg_exposure_1 = FactoryGirl.build(:drug_exposure, person: @person_little_my, drug_concept: @concept_drug_carbidopa, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_drug.id)
    durg_exposure_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    durg_exposure_2 = FactoryGirl.build(:drug_exposure, person: @person_moomin, drug_concept: @concept_drug_carbidopa_25mg_oral_tablet, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: Date.parse('2/1/2016'), interleave_datapoint_id: @interleave_datapoint_drug.id)
    durg_exposure_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    expect(DrugExposure.by_person(@person_little_my.person_id)).to match_array([durg_exposure_1])
  end


  it 'reports drug exposures by interleave datapoint', focus: false do
    durg_exposure_1 = FactoryGirl.build(:drug_exposure, person: @person_little_my, drug_concept: @concept_drug_carbidopa, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: Date.parse('1/1/2016'), interleave_datapoint_id: @interleave_datapoint_drug.id)
    durg_exposure_1.create_with_sub_datapoints!(@interleave_registry_cdm_source)
    durg_exposure_2 = FactoryGirl.build(:drug_exposure, person: @person_moomin, drug_concept: @concept_drug_carbidopa_25mg_oral_tablet, drug_type_concept: @concept_drug_prescription_written, drug_exposure_start_date: Date.parse('2/1/2016'), interleave_datapoint_id: @interleave_datapoint_drug_2.id)
    durg_exposure_2.create_with_sub_datapoints!(@interleave_registry_cdm_source)

    expect(DrugExposure.by_interleave_data_point(@interleave_datapoint_drug.id)).to match_array([durg_exposure_1])
  end

end