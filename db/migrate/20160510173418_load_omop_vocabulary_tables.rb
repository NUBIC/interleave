class LoadOmopVocabularyTables < ActiveRecord::Migration
  def up
    # ddl = IO.read('db/omop_common_data_model/PostgreSQL/VocabImport/OMOP CDM vocabulary load - PostgreSQL.sql')
    # execute ddl

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

  def down
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
