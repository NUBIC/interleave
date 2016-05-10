class CreateInterleavePeople < ActiveRecord::Migration
  def change
    create_table :interleave_people do |t|
      t.integer   :interleave_registry_affiliate_id, null: false
      t.integer   :person_id, null: false
      t.string    :first_name, null: false
      t.string    :last_name, null: false      
      t.string    :middle_name, null: true      
      t.timestamps null: false
    end
  end
end