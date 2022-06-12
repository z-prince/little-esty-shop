class MerchantBulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
  end

  def show
    @discount = Merchant.find(params[:merchant_id]).bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merch = Merchant.find(params[:merchant_id])
    merch.bulk_discounts.create!(bulk_dis_params)
    redirect_to merchant_bulk_discounts_path
  end

  def destroy
    merch = Merchant.find(params[:merchant_id])
    merch.bulk_discounts.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path
  end

  private

  def bulk_dis_params
    params.permit(:percentage_discount, :quantity)
  end
end
