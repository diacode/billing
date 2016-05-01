# == Schema Information
#
# Table name: items
#
#  id           :integer          not null, primary key
#  description  :string
#  cost         :decimal(11, 2)
#  period_start :date
#  period_end   :date
#  hours        :decimal(11, 2)
#  invoice_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#  project_id   :integer
#
# Indexes
#
#  index_items_on_invoice_id  (invoice_id)
#  index_items_on_project_id  (project_id)
#

class Item < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :project

  before_create :generate_period_description, if: :is_period?
  after_initialize :set_defaults

  def is_period?
    hours != nil
  end

  def full_description
    project_id.blank? ? description : "#{description} - #{project.name}"
  end

  private
    def generate_period_description
      self.description = "#{hours} horas de consultoría"
    end

    def set_defaults
      self.cost ||= 0
    end
end
