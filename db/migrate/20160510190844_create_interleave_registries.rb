class CreateInterleaveRegistries < ActiveRecord::Migration
  def change
    create_table :interleave_registries do |t|
      t.string   :name, null: false
      t.timestamps null: false
    end
  end
end
