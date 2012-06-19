class CreateProductsTables < ActiveRecord::Migration
  def up
    
    create_table  :products, :force => true do |t|
      t.string    :name
      t.text      :permissions
    end
    
    create_table :merchants_products, :id => false, :force => true do |t|
      t.integer :merchant_id, :null => false
      t.integer :product_id, :null => false
    end
    
    create_table :brands_products, :id => false, :force => true do |t|
      t.integer :brand_id, :null => false
      t.integer :product_id, :null => false
    end
    
    create_table :corporations_products, :id => false, :force => true do |t|
      t.integer :corporation_id, :null => false
      t.integer :product_id, :null => false
    end
    
    create_table :dealers_products, :id => false, :force => true do |t|
      t.integer :dealer_id, :null => false
      t.integer :product_id, :null => false
    end
    
    create_table :admins_products, :id => false, :force => true do |t|
      t.integer :admin_id, :null => false
      t.integer :product_id, :null => false
    end

  end

  def down
    drop_table :admins_products
    drop_table :dealers_products
    drop_table :corporations_products
    drop_table :brands_products
    drop_table :merchants_products
    drop_table :products
  end
end
