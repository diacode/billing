class AddLanguageToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :language, :string, default: 'en'

    Customer.update_all(language: 'es')
  end
end
