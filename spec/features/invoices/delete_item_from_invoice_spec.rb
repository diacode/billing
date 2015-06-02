require 'rails_helper'

feature 'Delete an item from an invoice', %q{
    As a User
    I want to delete an item from an invoice
    so that I remove wrong items.
  }, js: true do

  background do
    create_user_and_sign_in
    @project = create :project
    @invoice = create :invoice, customer: @project.customer
    @item = create :item, invoice_id: @invoice.id, cost: 1000
    visit invoice_path(@invoice)
  end

  scenario 'User deletes the existing item and saves it' do
    within '#invoice_detail tbody' do
      find('a.delete-item').click

      expect(page).to_not have_selector('tr span', text: '1.000 €')
      expect(page).to have_selector('td', text: 'No hay elementos facturados')
    end

    within '#invoice_detail tfoot' do
      expect(page).to have_selector('td.amount.vat-fee', text: '0 €')
      expect(page).to have_selector('td.amount.total', text: '0 €')
    end
  end
end
