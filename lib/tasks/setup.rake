namespace :setup do
  desc "Load ODHSI vocabularies"
  task(omop_vocabularies: :environment) do |t, args|
    Rails.root
    path = '/db/omop_common_data_model/PostgreSQL/VocabImport/CDMV5VOCAB/'

    ['DRUG_STRENGTH.csv',
     'CONCEPT.csv',
     'CONCEPT_RELATIONSHIP.csv',
     'CONCEPT_ANCESTOR.csv',
     'CONCEPT_SYNONYM.csv',
     'VOCABULARY.csv',
     'RELATIONSHIP.csv',
     'CONCEPT_CLASS.csv',
     'DOMAIN.csv'
    ].each do |file|
      file_path = "#{Rails.root}#{path}#{file}"
      table = file.gsub('.csv', '')
      puts file
      puts table
      puts file_path
      load_file(file_path, table)
    end
  end

  desc "Interleave Registries"
  task(interleave_registries: :environment) do |t, args|
    interleave_registry = InterleaveRegistry.where(name: 'Prostate SPORE').first_or_create
    interleave_registry_affiliate_northwestern = InterleaveRegistryAffiliate.where(name: 'Northwestern', interleave_registry: interleave_registry).first_or_create
    interleave_registry_affiliate_north_shore = InterleaveRegistryAffiliate.where(name: 'NorthShore University Health System', interleave_registry: interleave_registry).first_or_create

    interleave_registry_cdm_source = InterleaveRegistryCdmSource.where(cdm_source_name: InterleaveRegistryCdmSource::CDM_SOURCE_EX_NIHILO, interleave_registry: interleave_registry).first_or_create

    people = []
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).first, year_of_birth: 1971, month_of_birth: 12, day_of_birth: 10, race: Concept.standard.where(domain_id: 'Race').first, ethnicity: Concept.standard.where(domain_id: 'Ethnicity').first }, interleave: { first_name: 'little', last_name: 'my', middle_name: nil } }
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).last, year_of_birth: 1972, month_of_birth: 12, day_of_birth: 6, race: Concept.standard.where(domain_id: 'Race').last, ethnicity: Concept.standard.where(domain_id: 'Ethnicity').last }, interleave: { first_name: 'moomintroll', last_name: 'moomin', middle_name: nil } }
    people.each do |person|
      p = Person.where(person[:omop]).first_or_create
      InterleavePerson.where(person_id: p.person_id, interleave_registry_affiliate_id: interleave_registry_affiliate_northwestern.id).where(person[:interleave]).first_or_create
    end

    people = []
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).first, year_of_birth: 1981, month_of_birth: 12, day_of_birth: 10, race: Concept.standard.where(domain_id: 'Race').first, ethnicity: Concept.standard.where(domain_id: 'Ethnicity').first }, interleave: { first_name: 'Harold', last_name: 'Baines', middle_name: nil } }
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).last, year_of_birth: 1982, month_of_birth: 12, day_of_birth: 6, race: Concept.standard.where(domain_id: 'Race').last, ethnicity: Concept.standard.where(domain_id: 'Ethnicity').last }, interleave: { first_name: 'Paul', last_name: 'Konerko', middle_name: nil } }
    people.each do |person|
      p = Person.where(person[:omop]).first_or_create
      InterleavePerson.where(person_id: p.person_id, interleave_registry_affiliate_id: interleave_registry_affiliate_north_shore.id).where(person[:interleave]).first_or_create
    end

    relationship = Relationship.where(relationship_id: 'Has asso finding').first
    concept_pathology_finding = Concept.standard.where(vocabulary_id: Concept::VOCABULARY_ID_MEAS_TYPE, concept_name: 'Pathology finding').first #Pathology finding

    #datapoint diagnosis
    interleave_datapoint_diagnosis = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Diagnosis', domain_id: 'Condition', cardinality: 1, overlap: true,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NOT_APPICABLE).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_CONDITION, concept_code: '126906006').first #Neoplasm of prostate
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_diagnosis.id, concept: concept, column: 'condition_concept_id').first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_CONDITION, concept_code: '266569009').first #"Benign prostatic hyperplasia"
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_diagnosis.id, concept: concept, column: 'condition_concept_id').first_or_create

    #datapoint comorbidities
    interleave_datapoint_comorbidities = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Comorbidities', domain_id: 'Condition', cardinality: 0, overlap: false,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NOT_APPICABLE).first_or_create

    #datapoint trus
    interleave_datapoint_trus = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'TRUS', domain_id: 'Procedure', cardinality: 0, overlap: true,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NOT_APPICABLE).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_PROCEDURE, concept_code: '76872').first #Ultrasound, transrectal
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_trus.id, concept: concept, column: 'procedure_concept_id').first_or_create

    #datapoint biopsy
    interleave_datapoint_biopsy = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Biopsy', domain_id: 'Procedure', cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NOT_APPICABLE).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_PROCEDURE, concept_code: '55700').first #Biopsy, prostate; needle or punch, single or multiple, any approach
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, concept: concept, column: 'procedure_concept_id').first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_PROCEDURE, concept_code: '55705').first #Biopsy, prostate; incisional, any approach
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, concept: concept, column: 'procedure_concept_id').first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, concept_name: 'Primary Procedure').first #
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, concept: concept, column: 'procedure_type_concept_id').first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, concept_name: 'Secondary Procedure').first #
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, concept: concept, column: 'procedure_type_concept_id').first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_total_number_of_cores = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Total number of cores', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '44652-6').first #Total number of cores in Tissue core by CAP cancer protocols"
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_total_number_of_cores_positive = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Total number of cores positive', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '44651-8').first #Tissue cores.positive.carcinoma in Tissue core by CAP cancer protocols
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores_positive.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores_positive.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores_positive.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_gleason_primary = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Gleason primary', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST, range_low: 1, range_high: 5).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '44641-9').first #Gleason pattern.primary in Prostate tumor by CAP cancer protocols
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'value_as_number', value_as_number: 1).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'value_as_number', value_as_number: 2).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'value_as_number', value_as_number: 3).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'value_as_number', value_as_number: 4).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'value_as_number', value_as_number: 5).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_gleason_primary.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_gleason_secondary = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Gleason secondary', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST, range_low: 1, range_high: 5).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '44642-7').first #Gleason pattern.secondary in Prostate tumor by CAP cancer protocols
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'value_as_number', value_as_number: 1).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'value_as_number', value_as_number: 2).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'value_as_number', value_as_number: 3).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'value_as_number', value_as_number: 4).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'value_as_number', value_as_number: 5).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_gleason_secondary.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_gleason_tertiary = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Gleason tertiary', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_INTEGER_LIST, range_low: 1, range_high: 5).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '44643-5').first #Gleason pattern.tertiary in Prostate tumor by CAP cancer protocols
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'value_as_number', value_as_number: 1).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'value_as_number', value_as_number: 2).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'value_as_number', value_as_number: 3).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'value_as_number', value_as_number: 4).first_or_create
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'value_as_number', value_as_number: 5).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_gleason_tertiary.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_tissue_involved_by_tumor = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Tissue involved by tumor', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL, range_low: 0, range_high: 100).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '44654-2').first #Tissue involved by tumor in Prostate tumor by CAP cancer protocols
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_tissue_involved_by_tumor.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_tissue_involved_by_tumor.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_tissue_involved_by_tumor.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_biopsy_perineural = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Perineural invasion', domain_id: Measurement::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '33741-0').first #Perineural invasion by CAP cancer protocols
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_perineural.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_perineural.id, column: 'measurement_type_concept_id', concept: concept_pathology_finding, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_biopsy.id, interleave_sub_datapoint_id: interleave_datapoint_biopsy_perineural.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEAS_VALUE, concept_code: 'LA9633-4').first #Present
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_perineural.id, concept: concept, column: 'value_as_concept_id').first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEAS_VALUE, concept_code: 'LA9634-2').first #Absent
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_perineural.id, concept: concept, column: 'value_as_concept_id').first_or_create

    #TTD Biopsy Result  Likely will be an entry in condiiton occurrence
    # Normal
    # Prostatic Intraepithelial Neoplasia
    # Imflamation
    # Atypia
    # Unknown
    # Other
  end
end

def load_file(file_path, table)
  dbconn = ActiveRecord::Base.connection_pool.checkout
  raw  = dbconn.raw_connection
  count = nil

  result = raw.copy_data "COPY #{table} FROM STDIN WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'" do

    File.open(file_path, 'r').each do |line|
      raw.put_copy_data line
    end

  end

  count = dbconn.select_value("select count(*) from #{table}").to_i

  ActiveRecord::Base.connection_pool.checkin(dbconn)

  count
end