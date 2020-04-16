class AddTokenToUser < ActiveRecord::Migration[6.0]
  change_table :users do |t|
    ## Database authenticatable
    t.string :token
    t.string :auth_token
  end
end
