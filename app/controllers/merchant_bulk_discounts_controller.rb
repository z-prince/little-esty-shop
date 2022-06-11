class MerchantBulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:id]).bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:id])
  end

  def create
    merch = Merchant.find(params[:id])
    merch.bulk_discounts.create!(bulk_dis_params)
    redirect_to "/merchants/#{merch.id}/bulk_discounts"
  end

  private

  def bulk_dis_params
    params.permit(:percentage_discount, :quantity)
  end
end
