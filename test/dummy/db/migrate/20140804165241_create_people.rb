class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :name
      t.string :address
      t.text :bio
      t.boolean :married
      t.integer :kids

      t.timestamps
    end
  end
end
