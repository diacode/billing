class ProjectDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all

  def start
    l(object.start.to_date, format: :long) unless object.start.blank?
  end

  def ending
    l(object.ending.to_date, format: :long) unless object.ending.blank?
  end

  def budget
    unless object.budget.blank?
      number_to_currency(object.budget) 
    else
      "Sin determinar"
    end
  end

  def hours_agreed
    object.hours_agreed.blank? ? "-" : object.hours_agreed
  end

  def hours_spent
    object.hours_spent.blank? ? "0" : object.hours_spent.round(2)
  end

  def ratio
    "#{number_to_currency(object.ratio)}/hora" unless object.ratio.blank?
  end

  def days_left
    (object.time_left.to_i/(24 * 60 * 60)) unless object.time_left == nil
  end
end
