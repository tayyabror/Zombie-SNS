# frozen_string_literal: true

# Write queries for Survivor table here
class Survivor < ApplicationRecord
  has_many :survivor_inventory_items, dependent: :destroy
  has_many :inventory_items, through: :survivor_inventory_items

  accepts_nested_attributes_for :survivor_inventory_items
  
  scope :infected, -> { where(infected: true) }
  scope :healthy, -> { where(infected: false) }

  validate :validate_reported_by_uniqueness
  validates :name, :age, :gender, :latitude, :longitude, presence: true
  validates :age, numericality: { greater_than_or_equal_to: 0 }
  validates :latitude, numericality: { greater_than_or_equal_to: -90, less_than_or_equal_to: 90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  before_save :check_reports

  def check_reports
    return unless reported_by.size > 4

    self.infected = true
  end

  def validate_reported_by_uniqueness
    array_values = reported_by || []
    return unless array_values.uniq.length != array_values.length

    errors.add(:reported_by, 'contains duplicate values')
  end
end
