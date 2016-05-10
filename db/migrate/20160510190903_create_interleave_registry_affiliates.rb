class CreateInterleaveRegistryAffiliates < ActiveRecord::Migration
  def change
    create_table :interleave_registry_affiliates do |t|
      t.string    :name,                    null: false
      t.integer   :interleave_registry_id,  null: false
      t.timestamps null: false
    end
  end
end
