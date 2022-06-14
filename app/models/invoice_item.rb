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

  def best_discount
    bulk_discounts.where("#{quantity} >= quantity")
                  .select('bulk_discounts.*')
                  .group('bulk_discounts.id, merchants.id, items.id')
                  .order(percentage_discount: :desc)
                  .first
  end

  def discounted_revenue
    (1 - best_discount.percentage_discount.to_f / 100) * (quantity * unit_price)
  end
end
