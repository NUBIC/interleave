class CreateOmopCdmTables < ActiveRecord::Migration
  def up
    ddl = IO.read('db/omop_common_data_model/PostgreSQL/OMOP CDM ddl - PostgreSQL.sql')
    execute ddl
  end
  
  def down
  end
end