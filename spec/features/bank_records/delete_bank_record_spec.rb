require 'rails_helper'

feature 'Delete a Bank Record', %q{
    As a User
    I want to delete a Bank Record
    so that I can fix possible BBVA Importer issues.
  }, js: true do

  background do
    create_user_and_sign_in
    @bank_record = create(:bank_record)
    visit bank_records_path
  end

  scenario 'User deletes a bank record' do
    find(".delete-bank-record").trigger('click')
    expect(page).to have_text('Registro bancario borrado correctamente.')
  end
end
