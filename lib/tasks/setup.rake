namespace :setup do
  desc "Interleave Registries"
  task(interleave_registries: :environment) do |t, args|
    interleave_registry = InterleaveRegistry.where(name: 'Prostate SPORE').first_or_create
    interleave_registry_affiliate_northwestern = InterleaveRegistryAffiliate.where(name: 'Northwestern', interleave_registry: interleave_registry).first_or_create
    interleave_registry_affiliate_north_shore = InterleaveRegistryAffiliate.where(name: 'NorthShore University Health System', interleave_registry: interleave_registry).first_or_create

    interleave_registry_cdm_source = InterleaveRegistryCdmSource.where(cdm_source_name: 'Ex nihilo', interleave_registry: interleave_registry).first_or_create

    people = []
    people << { omop: { gender: Concept.where(domain_id: 'Gender').first, year_of_birth: 1971, month_of_birth: 12, day_of_birth: 10, race: Concept.where(domain_id: 'Race').first, ethnicity: Concept.where(domain_id: 'Ethnicity').first }, interleave: { first_name: 'little', last_name: 'my', middle_name: nil } }
    people << { omop: { gender: Concept.where(domain_id: 'Gender').last, year_of_birth: 1972, month_of_birth: 12, day_of_birth: 6, race: Concept.where(domain_id: 'Race').last, ethnicity: Concept.where(domain_id: 'Ethnicity').last }, interleave: { first_name: 'moomintroll', last_name: 'moomin', middle_name: nil } }
    people.each do |person|
      p = Person.where(person[:omop]).first_or_create
      InterleavePerson.where(person_id: p.person_id, interleave_registry_affiliate_id: interleave_registry_affiliate_northwestern.id).where(person[:interleave]).first_or_create
    end

    people = []
    people << { omop: { gender: Concept.where(domain_id: 'Gender').first, year_of_birth: 1981, month_of_birth: 12, day_of_birth: 10, race: Concept.where(domain_id: 'Race').first, ethnicity: Concept.where(domain_id: 'Ethnicity').first }, interleave: { first_name: 'Harold', last_name: 'Baines', middle_name: nil } }
    people << { omop: { gender: Concept.where(domain_id: 'Gender').last, year_of_birth: 1982, month_of_birth: 12, day_of_birth: 6, race: Concept.where(domain_id: 'Race').last, ethnicity: Concept.where(domain_id: 'Ethnicity').last }, interleave: { first_name: 'Paul', last_name: 'Konerko', middle_name: nil } }
    people.each do |person|
      p = Person.where(person[:omop]).first_or_create
      InterleavePerson.where(person_id: p.person_id, interleave_registry_affiliate_id: interleave_registry_affiliate_north_shore.id).where(person[:interleave]).first_or_create
    end

    interleave_datapoint_diagnosis = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Diagnosis', domain_id: 'Condition', cardinality: 1, unrestricted: false, overlap: true).first_or_create
    concept = Concept.where(domain_id: 'Condition', concept_code: '126906006').first #Neoplasm of prostate
    InterleaveDatapointConcept.where(interleave_datapoint_id: interleave_datapoint_diagnosis.id, concept_id: concept.concept_id).first_or_create
    concept = Concept.where(domain_id: 'Condition', concept_code: '266569009').first #"Benign prostatic hyperplasia"
    InterleaveDatapointConcept.where(interleave_datapoint_id: interleave_datapoint_diagnosis.id, concept_id: concept.concept_id).first_or_create

    interleave_datapoint_diagnosis = InterleaveDatapoint.where(interleave_registry_id: interleave_registry.id, name: 'Comorbidities', domain_id: 'Condition', cardinality: 0, unrestricted: true, overlap: false).first_or_create
  end
end