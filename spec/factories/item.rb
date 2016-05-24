FactoryGirl.define do
  factory :item do
    description 'Nuevo concepto'
    cost Money.new(300)
    invoice
    project
  end
end