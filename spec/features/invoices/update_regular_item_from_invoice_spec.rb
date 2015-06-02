require 'rails_helper'

feature 'Update a regular item from an invoice', %q{
    As a User
    I want to edit a regular item (not a period) from an invoice
    so that I can modify a previous wrong item.
  }, js: true do

  background do
    create_user_and_sign_in
    @project = create :project
    @invoice = create :invoice, customer: @project.customer
    @item = create :item, invoice_id: @invoice.id, cost: 1000
    visit invoice_path(@invoice)
  end

  scenario 'User updates the cost of the existing item and saves it' do
    within '#invoice_detail tbody' do
      find('a.edit-item').click
      find('input.subject').set('Concepto 1')
      find('input.cost').set(3000)
      find('a.save-item').click

      expect(page).to have_selector('tr span', text: '3.000 €')
    end

    within '#invoice_detail tfoot' do
      expect(page).to have_selector('td.amount.vat-fee', text: '630 €')
      expect(page).to have_selector('td.amount.total', text: '3.630 €')
    end
  end
end
