namespace :setup do
  desc "Load ODHSI vocabularies"
  task(omop_vocabularies: :environment) do |t, args|
    Rails.root
    path = '/db/omop_common_data_model/PostgreSQL/VocabImport/CDMV5VOCAB/'

# 'DRUG_STRENGTH.csv',
    [
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
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).first, year_of_birth: 1971, month_of_birth: 12, day_of_birth: 10, race: Concept.standard.where(domain_id: Concept::DOMAIN_ID_RACE).first, ethnicity: Concept.standard.where(domain_id: Concept::DOMAIN_ID_ETHNICITY).first }, interleave: { first_name: 'little', last_name: 'my', middle_name: nil } }
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).last, year_of_birth: 1972, month_of_birth: 12, day_of_birth: 6, race: Concept.standard.where(domain_id: Concept::DOMAIN_ID_RACE).last, ethnicity: Concept.standard.where(domain_id: Concept::DOMAIN_ID_ETHNICITY).last }, interleave: { first_name: 'moomintroll', last_name: 'moomin', middle_name: nil } }
    people.each do |person|
      p = Person.where(person[:omop]).first_or_create
      InterleavePerson.where(person_id: p.person_id, interleave_registry_affiliate_id: interleave_registry_affiliate_northwestern.id).where(person[:interleave]).first_or_create
    end

    people = []
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).first, year_of_birth: 1981, month_of_birth: 12, day_of_birth: 10, race: Concept.standard.where(domain_id: Concept::DOMAIN_ID_RACE).first, ethnicity: Concept.standard.where(domain_id: Concept::DOMAIN_ID_ETHNICITY).first }, interleave: { first_name: 'Harold', last_name: 'Baines', middle_name: nil } }
    people << { omop: { gender: Concept.standard.where(domain_id: Concept::DOMAIN_ID_GENDER).last, year_of_birth: 1982, month_of_birth: 12, day_of_birth: 6, race: Concept.standard.where(domain_id: Concept::DOMAIN_ID_RACE).last, ethnicity: Concept.standard.where(domain_id: Concept::DOMAIN_ID_ETHNICITY).last }, interleave: { first_name: 'Paul', last_name: 'Konerko', middle_name: nil } }
    people.each do |person|
      p = Person.where(person[:omop]).first_or_create
      InterleavePerson.where(person_id: p.person_id, interleave_registry_affiliate_id: interleave_registry_affiliate_north_shore.id).where(person[:interleave]).first_or_create
    end

    relationship = Relationship.where(relationship_id: 'Has asso finding').first
    concept_pathology_finding = Concept.standard.where(vocabulary_id: Concept::VOCABULARY_ID_MEAS_TYPE, concept_name: 'Pathology finding').first #Pathology finding
    concept_from_physical_examination = Concept.standard.where(vocabulary_id: Concept::VOCABULARY_ID_MEAS_TYPE, concept_name: 'From physical examination').first #From physical examination
    concept_lab_result = Concept.standard.where(vocabulary_id: Concept::VOCABULARY_ID_MEAS_TYPE, concept_name: 'Lab result').first #Lab result

    #datapoint drug exposure
    interleave_datapoint_drug_exposure = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Drug Exposure', domain_id: DrugExposure::DOMAIN_ID, cardinality: 0, overlap: true).first_or_create

    #datapoint diagnosis
    interleave_datapoint_diagnosis = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Diagnosis', domain_id: ConditionOccurrence::DOMAIN_ID, cardinality: 1, overlap: true,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NOT_APPICABLE).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_CONDITION, concept_code: '126906006').first #Neoplasm of prostate
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_diagnosis.id, concept: concept, column: 'condition_concept_id').first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_CONDITION, concept_code: '266569009').first #"Benign prostatic hyperplasia"
    InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_diagnosis.id, concept: concept, column: 'condition_concept_id').first_or_create

    #datapoint comorbidity
    interleave_datapoint_comorbidities = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Comorbidity', domain_id: 'Condition', cardinality: 0, overlap: false,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NOT_APPICABLE).first_or_create

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

    interleave_datapoint_weight = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Weight', domain_id: 'Measurement', cardinality: 0, overlap: true,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '3141-9').first #Body weight Measured
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_weight.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores.id, column: 'measurement_type_concept_id', concept: concept_lab_result, hardcoded: true).first_or_create

    interleave_datapoint_height = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Height', domain_id: 'Measurement', cardinality: 1, overlap: true,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: '3137-7').first #Body height Measured
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_height.id, column: 'measurement_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_biopsy_total_number_of_cores.id, column: 'measurement_type_concept_id', concept: concept_lab_result, hardcoded: true).first_or_create

    interleave_datapoint_psa_lab = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'PSA Lab', domain_id: 'Measurement', cardinality: 0, overlap: true,  value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_NUMBER_DECIMAL).first_or_create

    psa_concepts = [{ concept_name: 'Prostate Specific Ag Free [Mass/volume] in Body fluid' , concept_code: '59239-4' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Cerebral spinal fluid' , concept_code: '59231-1' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Peritoneal fluid' , concept_code: '59224-6' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Pleural fluid' , concept_code: '59232-9' },
    { concept_name: 'Prostate Specific Ag Free [Mass/volume] in Semen' , concept_code: '19205-4' },
    { concept_name: 'Prostate Specific Ag Free [Moles/volume] in Semen' , concept_code: '19206-2' },
    { concept_name: 'Prostate Specific Ag Free [Moles/volume] in Serum or Plasma' , concept_code: '19203-9' },
    { concept_name: 'Prostate Specific Ag Free [Units/volume] in Semen' , concept_code: '19204-7' },
    { concept_name: 'Prostate Specific Ag Free [Units/volume] in Serum or Plasma' , concept_code: '19201-3' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total [Pure mass fraction] in Serum or Plasma' , concept_code: '72576-2' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Body fluid' , concept_code: '59238-6' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Cerebral spinal fluid' , concept_code: '59235-2' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Peritoneal fluid' , concept_code: '59236-0' },
    { concept_name: 'Prostate Specific Ag Free/Prostate specific Ag.total in Pleural fluid' , concept_code: '59237-8' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Body fluid' , concept_code: '47738-0' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Cerebral spinal fluid' , concept_code: '59230-3' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Peritoneal fluid' , concept_code: '59223-8' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Pleural fluid' , concept_code: '59221-2' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Semen' , concept_code: '19199-9' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Serum or Plasma by Detection limit <= 0.01 ng/mL' , concept_code: '35741-8' },
    { concept_name: 'Prostate specific Ag [Mass/volume] in Urine' , concept_code: '34611-4' },
    { concept_name: 'Prostate specific Ag [Moles/volume] in Semen' , concept_code: '19200-5' },
    { concept_name: 'Prostate specific Ag [Moles/volume] in Serum or Plasma' , concept_code: '19197-3' },
    { concept_name: 'Prostate specific Ag [Presence] in Tissue by Immune stain' , concept_code: '10508-0' },
    { concept_name: 'Prostate specific Ag [Units/volume] in Semen' , concept_code: '19198-1' },
    { concept_name: 'Prostate specific Ag [Units/volume] in Serum or Plasma' , concept_code: '19195-7' },
    { concept_name: 'Prostate specific Ag.protein bound [Mass/volume] in Serum or Plasma' , concept_code: '33667-7' },
    { concept_name: 'Prostate specific Ag/Creatinine [Mass Ratio] in Urine' , concept_code: '48167-1' }].each do |psa_concept|
      concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_MEASUREMENT, concept_code: psa_concept[:concept_code]).first #Neoplasm of prostate
      InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_psa_lab.id, concept: concept, column: 'measurement_concept_id').first_or_create
      InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_psa_lab.id, column: 'measurement_type_concept_id', concept: concept_lab_result, hardcoded: true).first_or_create
    end

    #datapoint family history
    interleave_datapoint_family_history_of_disease_relationship = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, group_name: 'Family History of Disease', name: 'Family Relationship', domain_id: Observation::DOMAIN_ID, cardinality: 0, overlap: true, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_OBSERVATION, concept_code: '54136-7').first #"Relationship to patient family member [USSG-FHT]"
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_relationship.id, column: 'observation_concept_id', concept: concept, hardcoded: true).first_or_create

    ConceptRelationship.where(concept_id_1: concept.id, relationship_id: 'Has Answer').each do |concept_relationship|
      concept = Concept.standard.where(concept_id: concept_relationship.concept_id_2).first
      InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_relationship.id, concept: concept, column: 'value_as_concept_id').first_or_create
    end

    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, concept_name: 'Patient reported').first #Patient reported
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_relationship.id, column: 'observation_type_concept_id', concept: concept, hardcoded: true).first_or_create

    #subdatapoint
    interleave_datapoint_family_history_of_disease_disease = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Disease', domain_id: Observation::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_OBSERVATION, concept_code: '54116-9').first #History of diseases family member [USSG-FHT]
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_disease.id, column: 'observation_concept_id', concept: concept, hardcoded: true).first_or_create

    ConceptRelationship.where(concept_id_1: concept.id, relationship_id: 'Has Answer').each do |concept_relationship|
      concept = Concept.standard.where(concept_id: concept_relationship.concept_id_2).first
      InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_disease.id, concept: concept, column: 'value_as_concept_id').first_or_create
    end

    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, concept_name: 'Patient reported').first #Patient reported
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_disease.id, column: 'observation_type_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_relationship.id, interleave_sub_datapoint_id: interleave_datapoint_family_history_of_disease_disease.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create

    #subdatapoint
    interleave_datapoint_family_history_of_disease_age_range = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Age range at diagnosis', domain_id: Observation::DOMAIN_ID, cardinality: 1 , overlap: false, value_type: InterleaveDatapoint::VALUE_TYPE_VALUE_AS_CONCEPT).first_or_create
    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_OBSERVATION, concept_code: '54115-1').first #Age range at onset of disease family member [USSG-FHT]
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_age_range.id, column: 'observation_concept_id', concept: concept, hardcoded: true).first_or_create

    ConceptRelationship.where(concept_id_1: concept.id, relationship_id: 'Has Answer').each do |concept_relationship|
      concept = Concept.standard.where(concept_id: concept_relationship.concept_id_2).first
      InterleaveDatapointValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_age_range.id, concept: concept, column: 'value_as_concept_id').first_or_create
    end

    concept = Concept.standard.where(domain_id: Concept::DOMAIN_ID_TYPE_CONCEPT, concept_name: 'Patient reported').first #Patient reported
    InterleaveDatapointDefaultValue.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_age_range.id, column: 'observation_type_concept_id', concept: concept, hardcoded: true).first_or_create
    InterleaveDatapointRelationship.where(interleave_datapoint_id: interleave_datapoint_family_history_of_disease_relationship.id, interleave_sub_datapoint_id: interleave_datapoint_family_history_of_disease_age_range.id, relationship_concept_id: relationship.relationship_concept_id).first_or_create
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