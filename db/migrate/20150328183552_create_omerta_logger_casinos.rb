class CreateOmertaLoggerCasinos < ActiveRecord::Migration[4.2]
  def change
    create_table :omerta_logger_casinos do |t|
      t.integer :ext_casino_id, :limit => 2
      t.references :version, index: true
      t.references :user, index: true
      t.references :family, index: true
      t.integer :casino_type, :limit => 1
      t.integer :city, :limit => 1
      t.integer :profit
      t.integer :max_bet
      t.integer :protection, :limit => 1
      t.boolean :bankrupt
    end
  end
end
