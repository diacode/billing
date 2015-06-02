require 'rails_helper'

feature 'Create an invoice', %q{
    As a User
    I want to create a new invoice
    so that I can bill.
  }, js: true do

  background do
    create_user_and_sign_in
    @customer = create(:customer)
    visit new_invoice_path
  end

  scenario 'User creates a new invoice' do
    select(@customer.name, from: 'invoice_customer_id')
    click_on 'Continuar'
    expect(page).to have_text('No hay elementos facturados')
    expect(page).to have_text('#00001')
  end
end
