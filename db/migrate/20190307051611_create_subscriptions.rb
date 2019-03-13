class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :frequency
      t.integer :status
      t.timestamp :next_delivery
      t.timestamp :prev_delivery
      t.references :user
      t.references :product
      t.references :address
      t.timestamps
    end
  end
end
