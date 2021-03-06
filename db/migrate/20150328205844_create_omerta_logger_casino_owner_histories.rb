class CreateOmertaLoggerCasinoOwnerHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :omerta_logger_casino_owner_histories do |t|
      t.references :casino
      t.datetime :date
      t.references :user
      t.references :family
      t.index :casino_id, name: 'index_owner_casino_id'
    end
  end
end
