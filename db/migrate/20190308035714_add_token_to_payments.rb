class AddTokenToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :token, :string
  end
end
