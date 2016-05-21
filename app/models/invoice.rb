# == Schema Information
#
# Table name: invoices
#
#  id          :integer          not null, primary key
#  code        :string
#  expiration  :date
#  vat         :integer
#  created_at  :datetime
#  updated_at  :datetime
#  paid        :boolean          default("false")
#  customer_id :integer
#  currency    :string
#
# Indexes
#
#  index_invoices_on_customer_id  (customer_id)
#

class Invoice < ActiveRecord::Base
  # Associations
  belongs_to :customer
  has_many :items, dependent: :destroy

  # Scopes
  default_scope { order('created_at desc') }
  scope :paid, -> { where(paid: true) }
  scope :pending, -> { where(paid: false) }

  # Validations
  validates :customer, presence: true
  validates :code, uniqueness: true

  # Callbacks
  before_create :generate_code, if: Proc.new { |invoice| invoice.code.blank? }
  before_create :set_default_expiration, if: Proc.new { |invoice| invoice.expiration.blank? }
  after_initialize :set_defaults

  # Public methods
  def subtotal
    items.sum(:cost_cents)/100
  end

  def vat_fee
    subtotal*self.vat.to_f/100.0
  end

  def total
    subtotal+vat_fee
  end

  def to_s
    "Factura #{code} - #{customer.name}"
  end

  def expired?
    !expiration.blank? && expiration < Date.today
  end

  private

  def generate_code
    if Invoice.count > 0
      new_code = Invoice.unscoped.order('code DESC').first.code.to_i + 1
    else
      if ENV['LAST_LEGACY_INVOICE_NUMBER'].present?
        new_code = ENV['LAST_LEGACY_INVOICE_NUMBER'].to_i+1
      else
        new_code = 1
      end
    end

    self.code = new_code.to_s.rjust(5, '0')
  end

  def set_defaults
    self.vat ||= 21
  end

  def set_default_expiration
    self.expiration ||= Date.today+2.weeks
  end
end
