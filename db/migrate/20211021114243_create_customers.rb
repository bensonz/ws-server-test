class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :country
      t.string :locality
      t.string :postal_code
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :note
      t.string :phone_number

      t.timestamps
    end
  end
end
