class CreateInterleaveDatapoints < ActiveRecord::Migration
  def change
    create_table :interleave_datapoints do |t|
      t.integer   :interleave_registry_id,  null: false
      t.string    :name,                    null: false
      t.string    :domain_id,               null: false
      t.integer   :cardinality,             null: false
      t.boolean   :overlap,                 null: false
      t.string    :value_type,              null: true
      t.decimal   :range_low,               null: true
      t.decimal   :range_high,              null: true
      t.timestamps                          null: false
    end
  end
end