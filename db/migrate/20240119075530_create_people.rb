class CreatePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :people do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :passport_series, null: false
      t.string :passport_number, null: false
      t.string :passport_issued_by, null: false
      t.date :passport_issued_on, null: false
      t.timestamps
    end
  end
end
