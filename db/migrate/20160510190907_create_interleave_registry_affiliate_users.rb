class CreateInterleaveRegistryAffiliateUsers < ActiveRecord::Migration
  def change
    create_table :interleave_registry_affiliate_users do |t|
      t.integer   :interleave_registry_affiliate_id, null: false
      t.integer   :interleave_user_id, null: false
      t.timestamps null: false
    end
  end
end