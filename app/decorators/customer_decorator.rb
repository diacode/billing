class CustomerDecorator < Draper::Decorator
  delegate_all

  def billing_info
    object.billing_info.present? ? object.billing_info : "Datos no indicados"
  end
end
