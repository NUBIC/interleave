class LoadOmopVocabularyTables < ActiveRecord::Migration
  def up
    ddl = IO.read('db/omop_common_data_model/PostgreSQL/VocabImport/OMOP CDM vocabulary load - PostgreSQL.sql')
    execute ddl
  end
  
  def down
  end
end