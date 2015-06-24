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
    account.fetch_transactions(start_date: Date.today - 2.years, end_date: Date.today)
  end

  def import_last
  end
end
