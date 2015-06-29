# TODO: Implement specific account importing. Right now it only imports transactions from
# the first bank account available in our bank. It should work like that if there is no account
# id specified in billing.yml config file. If it's explicitly specified then it should import 
# transactions from that account
class BankRecordImporter
  def initialize
    username = ::BillingConfig['bank_account']['username'].to_s
    password = ::BillingConfig['bank_account']['password'].to_s

    case ::BillingConfig['bank_account']['entity']
      when 'bbva' then @bank = BankScrap::Bbva.new(username, password)
      when 'ing' then @bank = BankScrap::Ing.new(username, password, extra_args: {'birthday' => ::BillingConfig['bank_account']['birthday']})
      when 'bankinter' then @bank = BankScrap::Bankinter.new(username, password)
    end
  end  

  # By default this method will import all bank records from last two years. If you need 
  # to get more try changing start_date parameter. Note that there are APIs that don't allow
  # to get more bank records older than 2 years.
  def import_all
    account = @bank.accounts.first
    transactions = account.fetch_transactions(start_date: Date.today - 2.years, end_date: Date.today)
    transactions.reverse!
    transactions.each do |t|
      BankRecord.create(
        subject: t.description,
        amount: t.amount,
        balance: t.balance,
        operation_at: t.effective_date,
        value_at: t.effective_date,
        transaction_id: t.id
      )
    end
  end

  def import_last
    account = @bank.accounts.first
    transactions = account.fetch_transactions(start_date: Date.today - 2.days, end_date: Date.today)
    transactions.reverse!
    transactions.each do |t|
      unless BankRecord.exists?(transaction_id: t.id)
        BankRecord.create(
          subject: t.description,
          amount: t.amount,
          balance: t.balance,
          operation_at: t.effective_date,
          value_at: t.effective_date,
          transaction_id: t.id
        )
      end
    end
  end
end
