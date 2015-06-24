class HomeController < BaseController
  def index
    @monthly_income = BankRecord.current_month.income.sum(:amount)
    @monthly_expenses = BankRecord.current_month.expenses.sum(:amount)
    @bank_records = BankRecord.limit(5)
    @invoices = Invoice.limit(5)
    @pending = Invoice.pending.to_a.sum(&:total)
    @balance = @bank_records.any? ? @bank_records.first.balance : 0
  end
end