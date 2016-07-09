class AddPaymentColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :payment, :boolean, default: false
  end
end
