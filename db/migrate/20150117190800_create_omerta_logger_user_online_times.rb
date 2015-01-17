class CreateOmertaLoggerUserOnlineTimes < ActiveRecord::Migration
  def change
    create_table :omerta_logger_user_online_times do |t|
      t.references :user, index: true
      t.datetime :start
      t.datetime :end
    end
  end
end
