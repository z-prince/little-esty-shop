class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :transactions, through: :invoice
  has_many :bulk_discounts, through: :merchant

  enum status: %w[pending packaged shipped]

  def self.item_revenue
    sum('quantity * unit_price')
  end
end
