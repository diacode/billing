require 'rails_helper'

feature 'Delete an invoice', %q{
    As a User
    I want to delete an invoice.
  }, js: true do

  background do
    create_user_and_sign_in
    @invoice = create(:invoice, code: '00001')
    visit invoice_path(@invoice)
  end

  scenario 'User deletes a new invoice' do
    click_on 'delete_invoice'
    expect(page).to have_text('Factura borrada correctamente.')
    expect(page).to_not have_text('00001')
  end
end
