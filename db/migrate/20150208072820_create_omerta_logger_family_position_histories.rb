class CreateOmertaLoggerFamilyPositionHistories < ActiveRecord::Migration[4.2]
  def change
    create_table :omerta_logger_family_position_histories do |t|
      t.datetime :date
      t.integer :position
      t.references :family, index: true
    end
  end
end
