require 'rails_helper'

feature 'Add a regular item to an invoice', %q{
    As a User
    I want to add a regular item (not a period) to an invoice
    so that I can bill other concepts besides periods.
  }, js: true do

  background do
    create_user_and_sign_in
    @project = create :project
    @invoice = create :invoice, customer: @project.customer
    visit invoice_path(@invoice)
  end

  scenario 'User creates a valid item for a project and saves it' do
    click_on 'Añadir concepto'
    click_on 'Concepto normal'

    within '#invoice_detail tbody' do
      find('input.subject').set('Concepto 1')
      find('input.cost').set(3000)
      find('a.save-item').click

      expect(page).to have_selector('tr span', text: 'Concepto 1')
      expect(page).to have_selector('tr span', text: '3.000 €')
    end

    within '#invoice_detail tfoot' do
      expect(page).to have_selector('td.amount.vat-fee', text: '630 €')
      expect(page).to have_selector('td.amount.total', text: '3.630 €')
    end
  end

  scenario 'User creates a new item but changes his mind and cancels it' do
    click_on 'Añadir concepto'
    click_on 'Concepto normal'

    within '#invoice_detail tbody' do
      find('a.cancel-item-edition').click

      expect(page).to have_selector('tr td', text: 'No hay elementos facturados')
    end

    within '#invoice_detail tfoot' do
      expect(page).to have_selector('td.amount.total', text: '0 €')
    end
  end
end
