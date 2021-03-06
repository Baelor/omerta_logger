class CreateOmertaLoggerBusinessObjectOwnerHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :omerta_logger_business_object_owner_histories do |t|
      t.references :business_object
      t.datetime :date
      t.references :user
      t.references :family
      t.index :business_object_id, name: 'index_owner_business_object_id'
    end
  end
end
