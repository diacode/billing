# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  stack            :text
#  start            :datetime
#  ending           :datetime
#  hours_agreed     :integer
#  tracking_id      :string
#  customer_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  tracking_service :integer
#  status           :integer
#  hours_spent      :decimal(11, 4)   default("0")
#  currency         :string           default("EUR")
#  budget_cents     :integer          default("0"), not null
#  budget_currency  :string           default("EUR"), not null
#  ratio_cents      :integer          default("0"), not null
#  ratio_currency   :string           default("EUR"), not null
#
# Indexes
#
#  index_projects_on_customer_id  (customer_id)
#

class Project < ActiveRecord::Base
  enum status: [:active, :finished]
  enum tracking_service: [:toggl, :harvest]

  # Money columns
  monetize :budget_cents
  monetize :ratio_cents

  # Associations
  belongs_to :customer
  has_many :items
  has_many :invoices, through: :items

  # Validations
  validates :name, :customer, presence: true

  # Scopes
  scope :trackable, -> { where('tracking_id IS NOT NULL').where('tracking_service IS NOT NULL') }
  scope :priced, -> { where('ratio_cents IS NOT NULL') }

  # Hooks
  before_save :set_currencies

  def current_time_gap(accomplished_hours)
    a = ending-start
    b = Time.zone.now-self.start
    theoretical_hours = b*hours_agreed.to_f/a
    (accomplished_hours-theoretical_hours).round
  end

  def last_day_invoiced
    Item.where(invoice_id: self.invoice_ids)
      .order('period_end DESC')
      .pluck(:period_end)
      .first
  end

  def time_left
    self.ending-DateTime.now unless self.ending.blank?
  end

  def percent_elapsed
    total_time_provided = self.ending-self.start
    time_left = self.time_left
    100.0-(time_left*100/total_time_provided)
  end

  def invoiced
    items.to_a.sum(&:cost)
  end

  def refresh_hours_spent
    tracker = TimeTracking::Tracker.new(tracking_service)
    self.hours_spent = tracker.project_tracked_time(tracking_id).round(2)
    save
  end

  def self.refresh_projects_hours_spent
    projects = Project.active.trackable
    projects.each do |project|
      project.refresh_hours_spent
    end
  end

  def set_currencies
    self.budget_currency = self.currency
    self.ratio_currency = self.currency
  end
end
