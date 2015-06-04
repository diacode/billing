# TODO: Implement this as generic importer



# BBVA Importer
# =============
# BBVA Importer is a namespace where we have two tasks to retrieve
# bank transactions. The first retrieves all the records and the second one 
# just the records of the current day. BBVA API returns the records sorted
# by date DESC however in both cases we will insert them in the database
# using the reverse order. We have to do this way if we want to keep 
# track of the balance.
namespace :bbva_importer do
  task :import_all => :setup_logger do
    bbva = BBVA::API.new(ENV['BBVA_USER'], ENV['BBVA_PASSWORD'])
    balance = bbva.get_balance.to_f
    transactions = bbva.get_transactions(start_date: Date.today-2.years, end_date: Date.today)
    bank_records_to_save = []

    transactions.each do |t|
      bank_record_params = bbva_transaction_to_hash(t)
      bank_record_params[:balance] = balance
      bank_records_to_save << BankRecord.new(bank_record_params)
      balance -= bank_record_params[:amount]
    end

    bank_records_to_save.reverse!

    bank_records_to_save.each { |br| br.save }
  end

  task :import_recent => :setup_logger do
    bbva = BBVA::API.new(ENV['BBVA_USER'], ENV['BBVA_PASSWORD'])
    balance = bbva.get_balance.to_f
    # We retrieve records from last two days
    transactions = bbva.get_transactions(start_date: Date.yesterday, end_date: Date.today)

    if transactions.any?
      bank_records_to_save = []
  
      transactions.each do |t|
        bank_record_params = bbva_transaction_to_hash(t)
        bank_record_params[:balance] = balance
        new_br = BankRecord.new(bank_record_params)
        # We stop considering transactions to add once we match a existing 
        # record in the database with the same date, amount and balance.
        break if BankRecord.exists?(operation_at: new_br.operation_at, amount: new_br.amount, balance: new_br.balance)
        bank_records_to_save << new_br
        balance -= bank_record_params[:amount]
      end

      if bank_records_to_save.any?
        bank_records_to_save.reverse!
        bank_records_to_save.each do |br| 
          br.save
          # Notifying via HipChat
          # TODO: We should use a background job to handle this
          # call. Probably the best is to wait until ActiveJob is part of Rails 4.2 so that
          # we avoid to install another dependency like Sidekiq or DelayedJobs
          ChatNotifications::ChatNotifications.new.notify_bank_record(br) if Rails.env == "production"
        end
      end
    else
      @logger.info "No hay transacciones en la cuenta para los últimos dos días"
    end
  end

  # Needed functions
  def bbva_transaction_to_hash(transaction)
    {
      operation_at: Date.strptime(transaction['FECHAOP'], '%Y%m%d'),
      value_at: Date.strptime(transaction['FECHAVAL'], '%Y%m%d'),
      subject: transaction['DESCRIPCION'],
      amount: transaction['IMPORTECTA'].to_f
    }
  end
end
