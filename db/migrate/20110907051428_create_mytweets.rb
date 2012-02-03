class CreateMytweets < ActiveRecord::Migration
  def self.up
    create_table :mytweets do |t|
      t.string :tweet

      t.timestamps
    end
  end

  def self.down
    drop_table :mytweets
  end
end
