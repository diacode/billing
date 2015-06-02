class HomeController < BaseController
  def index
    @balance = BankRecord.limit(1).pluck(:balance).first
    @monthly_income = BankRecord.current_month.income.sum(:amount)
    @monthly_expenses = BankRecord.current_month.expenses.sum(:amount)
    @bank_records = BankRecord.limit(5)
    @invoices = Invoice.limit(5)
    @pending = Invoice.pending.to_a.sum(&:total)
  end
end