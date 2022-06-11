class MerchantBulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:id]).bulk_discounts
  end

  def new; end
end
