class CreateProductsTables < ActiveRecord::Migration
  def up
    
    create_table  :products, :force => true do |t|
      t.string    :name
      t.text      :permissions
      t.datetime  :deleted_at
    end
    
    create_table :merchants_products, :id => false, :force => true do |t|
      t.integer :merchant_id, :null => false
      t.integer :product_id, :null => false
    end

  end

  def down
    drop_table :products
    drop_table :businesses_products
  end
end
