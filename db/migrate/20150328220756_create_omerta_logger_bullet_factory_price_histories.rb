class CreateOmertaLoggerBulletFactoryPriceHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :omerta_logger_bullet_factory_price_histories do |t|
      t.references :bullet_factory
      t.datetime :date
      t.integer :price, :limit => 2
      t.index :bullet_factory_id, name: 'index_price_bullet_factory_id'
    end
  end
end
