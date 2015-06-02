#Sets up logging - should only be called from other rake tasks
task setup_logger: :environment do
  @logger           = Logger.new(STDOUT)
  @logger.level     = Logger::INFO
  Rails.logger      = @logger
end