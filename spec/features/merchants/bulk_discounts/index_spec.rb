require 'rails_helper'

RSpec.describe 'bulk_discounts index' do
  before :each do
    @merch1 = Merchant.create!(name: 'Floopy Fopperations')
    @merch2 = Merchant.create!(name: 'Goopy Gopperations')
    @item1 = @merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450)
    @item2 = @merch1.items.create!(name: 'A-Team Original', description: 'the better', unit_price: 950)

    @cust1 = Customer.create!(first_name: 'Mark', last_name: 'Ruffalo')
    @cust2 = Customer.create!(first_name: 'Jim', last_name: 'Raddle')
    @cust3 = Customer.create!(first_name: 'Bryan', last_name: 'Cranston')
    @cust4 = Customer.create!(first_name: 'Walter', last_name: 'White')
    @cust5 = Customer.create!(first_name: 'Hank', last_name: 'Williams')
    @cust6 = Customer.create!(first_name: 'Sammy', last_name: 'Sosa')
    @cust7 = Customer.create!(first_name: 'Barry', last_name: 'Bonds')

    @inv1 = @cust1.invoices.create!(status: 'in progress')
    @inv2 = @cust2.invoices.create!(status: 'completed')
    @inv3 = @cust3.invoices.create!(status: 'completed')
    @inv4 = @cust4.invoices.create!(status: 'completed')
    @inv5 = @cust5.invoices.create!(status: 'completed')
    @inv6 = @cust6.invoices.create!(status: 'completed')
    @inv7 = @cust7.invoices.create!(status: 'completed')

    InvoiceItem.create!(item_id: @item1.id.to_s, invoice_id: @inv1.id.to_s, quantity: 100, unit_price: 1000,
                        status: 1)
    InvoiceItem.create!(item_id: @item2.id.to_s, invoice_id: @inv2.id.to_s, quantity: 200, unit_price: 2000,
                        status: 1)
    InvoiceItem.create!(item_id: @item1.id.to_s, invoice_id: @inv3.id.to_s, quantity: 200, unit_price: 2000,
                        status: 1)
    InvoiceItem.create!(item_id: @item2.id.to_s, invoice_id: @inv4.id.to_s, quantity: 200, unit_price: 2000,
                        status: 1)
    InvoiceItem.create!(item_id: @item1.id.to_s, invoice_id: @inv5.id.to_s, quantity: 200, unit_price: 2000,
                        status: 1)
    InvoiceItem.create!(item_id: @item2.id.to_s, invoice_id: @inv6.id.to_s, quantity: 200, unit_price: 2000,
                        status: 1)
    InvoiceItem.create!(item_id: @item1.id.to_s, invoice_id: @inv7.id.to_s, quantity: 200, unit_price: 2000,
                        status: 1)

    @inv1.transactions.create!(result: 0)
    @inv1.transactions.create!(result: 0)
    @inv1.transactions.create!(result: 0)

    @inv2.transactions.create!(result: 0)
    @inv2.transactions.create!(result: 0)
    @inv2.transactions.create!(result: 0)

    @inv3.transactions.create!(result: 0)
    @inv3.transactions.create!(result: 0)
    @inv3.transactions.create!(result: 0)
    @inv3.transactions.create!(result: 0)

    @inv4.transactions.create!(result: 0)
    @inv4.transactions.create!(result: 0)
    @inv4.transactions.create!(result: 0)
    @inv4.transactions.create!(result: 1)
    @inv4.transactions.create!(result: 1)
    @inv4.transactions.create!(result: 1)
    @inv4.transactions.create!(result: 1)

    @inv5.transactions.create!(result: 0)
    @inv5.transactions.create!(result: 0)
    @inv5.transactions.create!(result: 0)
    @inv5.transactions.create!(result: 0)
    @inv5.transactions.create!(result: 0)

    @inv6.transactions.create!(result: 1)
    @inv6.transactions.create!(result: 1)
    @inv6.transactions.create!(result: 1)
    @inv6.transactions.create!(result: 1)

    @inv7.transactions.create!(result: 0)

    @bd1 = @merch1.bulk_discounts.create!(percentage_discount: 20, quantity: 30)
    @bd2 = @merch1.bulk_discounts.create!(percentage_discount: 30, quantity: 50)
    @bd3 = @merch1.bulk_discounts.create!(percentage_discount: 70, quantity: 90)
    @bd3 = @merch2.bulk_discounts.create!(percentage_discount: 69, quantity: 28)
  end
  it 'lists all discounts and their percantage / quantity with a link to the show page' do
    visit merchant_bulk_discounts_path(merchant_id: @merch1.id)
    expect(page).to have_content('Percentage Discount: 20')

    expect(page).to have_content('Percentage Discount: 30')

    expect(page).to have_content('Percentage Discount: 70')

    expect(page).to_not have_content('Percentage Discount: 69')

    expect(page).to have_content('Quantity: 30')

    expect(page).to have_content('Quantity: 50')

    expect(page).to have_content('Quantity: 90')

    expect(page).to_not have_content('Quantity: 28')
  end

  it 'links to each discount show page' do
    visit merchant_bulk_discounts_path(merchant_id: @merch1.id)

    within "#bulkDiscount#{@bd1.id}" do
      click_link('Discount Show Page')
    end

    expect(current_path).to eq "/merchants/#{@merch1.id}/bulk_discounts/#{@bd1.id}"
    expect(page).to have_content('Percentage Discount: 20')

    expect(page).to_not have_content('Percentage Discount: 30')

    expect(page).to have_content('Quantity: 30')

    expect(page).to_not have_content('Quantity: 50')
  end

  it 'can create a bulk discount' do
    visit merchant_bulk_discounts_path(merchant_id: @merch1.id)
    click_link('Create New Discount')

    expect(current_path).to eq(new_merchant_bulk_discount_path(merchant_id: @merch1.id))

    fill_in(:percentage_discount, with: '38')

    fill_in(:quantity, with: '25')

    click_button('Submit')

    expect(current_path).to eq "/merchants/#{@merch1.id}/bulk_discounts"

    expect(page).to have_content('Percentage Discount: 38')

    expect(page).to have_content('Quantity: 25')
  end

  it 'can delete a discount' do
    visit merchant_bulk_discounts_path(merchant_id: @merch1.id)

    within "#bulkDiscount#{@bd1.id}" do
      click_link('Delete Discount')
    end

    expect(current_path).to eq "/merchants/#{@merch1.id}/bulk_discounts"

    expect(page).to_not have_content('Percentage Discount: 20')

    expect(page).to_not have_content('Quantity: 30')

    expect(page).to have_content('Percentage Discount: 30')

    expect(page).to have_content('Percentage Discount: 70')

    expect(page).to have_content('Quantity: 50')

    expect(page).to have_content('Quantity: 90')
  end

  it 'shows the next 3 holidays' do
    visit merchant_bulk_discounts_path(merchant_id: @merch1.id)

    within '#nextThreeHolidays' do
      expect(page).to have_content(@next_three_holidays[0].name)

      expect(page).to have_content(@next_three_holidays[0].date)

      expect(page).to have_content(@next_three_holidays[1].name)

      expect(page).to have_content(@next_three_holidays[1].date)

      expect(page).to have_content(@next_three_holidays[2].name)

      expect(page).to have_content(@next_three_holidays[2].date)
    end
  end
end
