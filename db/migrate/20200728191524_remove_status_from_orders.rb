class RemoveStatusFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :status, :integer
  end
end
