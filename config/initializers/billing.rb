::BillingConfig = YAML.load(ERB.new(File.new("#{Rails.root}/config/billing.yml").read).result)[Rails.env]
