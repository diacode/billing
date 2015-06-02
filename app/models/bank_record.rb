# == Schema Information
#
# Table name: bank_records
#
#  id           :integer          not null, primary key
#  subject      :string(255)
#  amount       :decimal(11, 2)
#  balance      :decimal(11, 2)
#  operation_at :date
#  value_at     :date
#  created_at   :datetime
#  updated_at   :datetime
#

class BankRecord < ActiveRecord::Base
  include PgSearch

  # Scopes
  default_scope { order('operation_at desc, id desc') }
  scope :income, -> { where('amount > 0') }
  scope :expenses, -> { where('amount < 0') }
  scope :current_month, -> {
    where(operation_at: Date.today.at_beginning_of_month..Date.today.at_end_of_month) 
  }

  # PgSearch scope
  pg_search_scope :search_by_subject, 
                  against: :subject,
                  using: {
                    tsearch: {
                      prefix: true,
                      normalization: 2,
                      any_word: true
                    }
                  }

  def recent?
    operation_at == Date.today
  end
end
