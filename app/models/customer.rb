# == Schema Information
#
# Table name: customers
#
#  id           :integer          not null, primary key
#  name         :string
#  billing_info :text
#  created_at   :datetime
#  updated_at   :datetime
#  email        :string
#  picture      :string
#  language     :string           default("en")
#

class Customer < ActiveRecord::Base
  validates :name, presence: true

  # Associations
  has_many :projects
  has_many :invoices

  # Carrierwave
  mount_uploader :picture, CustomerPictureUploader
end
