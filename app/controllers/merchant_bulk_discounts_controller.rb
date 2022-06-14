class MerchantBulkDiscountsController < ApplicationController
  def index
    @discounts = Merchant.find(params[:merchant_id]).bulk_discounts
    @holidays = HolidayFacade.new
  end

  def show
    @discount = Merchant.find(params[:merchant_id]).bulk_discounts.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    merch = Merchant.find(params[:merchant_id])
    merch.bulk_discounts.create!(percentage_discount: params[:percentage_discount],
                                 quantity: params[:quantity], merchant_id: params[:merchant_id])
    redirect_to merchant_bulk_discounts_path
  end

  def destroy
    merch = Merchant.find(params[:merchant_id])
    merch.bulk_discounts.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path
  end

  def edit
    @discount = Merchant.find(params[:merchant_id]).bulk_discounts.find(params[:id])
  end

  def update
    discount = Merchant.find(params[:merchant_id]).bulk_discounts.find(params[:id])
    discount.update(bulk_dis_params)
    redirect_to merchant_bulk_discount_path(merchant_id: discount.merchant.id, id: discount.id)
  end

  # def update
  #   discount = BulkDiscount.find(params[:id])
  #   merchant = discount.merchant
  #   discount.update(bulk_discount_params)
  #   redirect_to merchant_bulk_discount_path(merchant, discount)
  # end

  private

  def bulk_dis_params
    params.permit(:percentage_discount, :quantity, :merchant_id)
  end
end
