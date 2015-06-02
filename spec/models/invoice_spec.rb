# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  expiration  :date
#  vat         :integer
#  created_at  :datetime
#  updated_at  :datetime
#  paid        :boolean          default(FALSE)
#  customer_id :integer
#
# Indexes
#
#  index_invoices_on_customer_id  (customer_id)
#

require 'rails_helper'

describe Invoice do
  # This tests save method since we can't test the private method
  # we are interested in which is the callback generate_code
  describe ".save" do
    context "when there isn't any previous invoice and it isn't specified any legacy invoice number" do
      before do 
        @invoice = build(:invoice)
        @invoice.save
      end

      it 'should set code as 00001' do 
        expect(@invoice.code).to eq('00001')
      end
    end

    context "when there isn't any previous invoice and it is specified a legacy invoice number" do
      before do
        ENV['LAST_LEGACY_INVOICE_NUMBER'] = '00099'
        @invoice = build(:invoice)
        @invoice.save
      end

      it 'should set 000100 as code' do
        expect(@invoice.code).to eq('00100')
      end
    end

    context "when there already is a previous invoice in the system" do
      before do 
        previous_invoice = create(:invoice, code: '00015')
        @invoice = build(:invoice)
        @invoice.save
      end

      it 'should set the next code' do
        expect(@invoice.code).to eq('00016')
      end
    end
  end
end
