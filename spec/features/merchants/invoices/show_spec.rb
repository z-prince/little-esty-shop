require 'rails_helper'

RSpec.describe 'Merchant Invoice Show Page' do
  describe 'Merchant Invoice Show Page' do
    before :each do
      @merch1 = Merchant.create!(name: 'Floopy Fopperations')
      @merch2 = Merchant.create!(name: 'Beauty Products 101')
      @customer1 = Customer.create!(first_name: 'Joe', last_name: 'Bob')
      @item1 = @merch1.items.create!(name: 'Floopy Original', description: 'the best', unit_price: 450)
      @item2 = @merch1.items.create!(name: 'Floopy Updated', description: 'the better', unit_price: 950)
      @item3 = @merch1.items.create!(name: 'Floopy Retro', description: 'the OG', unit_price: 550)
      @item4 = @merch2.items.create!(name: 'Floopy Geo', description: 'the OG', unit_price: 550)
      @invoice1 = @customer1.invoices.create!(status: 0)
      @invoice2 = @customer1.invoices.create!(status: 0)
      InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 1000, status: 0)
      InvoiceItem.create!(item_id: @item2.id, invoice_id: @invoice1.id, quantity: 10, unit_price: 1300, status: 1)
      InvoiceItem.create!(item_id: @item3.id, invoice_id: @invoice1.id, quantity: 20, unit_price: 2000, status: 1)
      InvoiceItem.create!(item_id: @item4.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 1000, status: 2)
      InvoiceItem.create!(item_id: @item4.id, invoice_id: @invoice2.id, quantity: 5, unit_price: 1000, status: 2)
    end

    it 'displays all items on invoice including name, quantity, price and status' do
      visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"
      within "#invoice-item-#{@item1.id}" do
        expect(page).to have_content('Name: Floopy Original')
        expect(page).to have_content('Quantity: 5')
        expect(page).to have_content('Unit Price: 1000')
        expect(page).to have_content('Status: pending')
        expect(page).to_not have_content('Name: Floopy Geo')
        expect(page).to_not have_content('Status: cancelled')
      end
      within "#invoice-item-#{@item3.id}" do
        expect(page).to have_content('Name: Floopy Retro')
        expect(page).to have_content('Quantity: 20')
        expect(page).to have_content('Unit Price: 2000')
        expect(page).to have_content('Status: packaged')
        expect(page).to_not have_content('Name: Floopy Geo')
        expect(page).to_not have_content('Quantity: 5')
        expect(page).to_not have_content('Unit Price: 1000')
        expect(page).to_not have_content('Status: Cancelled')
      end
      expect(page).to_not have_content('Name: Floopy Geo')
    end

    it 'shows the total revenue from all items on invoice' do
      visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"
      expect(page).to have_content('Total Revenue: 58000')
    end

    it 'will be able to update item on a merchants invoice' do
      visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"

      expect(page).to have_content('Status:')
      within "#invoice-item-#{@item3.id}" do
        select 'shipped', from: 'status'
        click_button 'Update Item Status'
      end

      expect(current_path).to eq("/merchants/#{@merch1.id}/invoices/#{@invoice1.id}")
      expect(page).to have_content('Status: shipped')
    end

    it 'shows the discounted revenue for this invoice' do
      @merch1.bulk_discounts.create(percentage_discount: 8, quantity: 20)
      @merch1.bulk_discounts.create(percentage_discount: 5, quantity: 10)

      visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"
      expect(page).to have_content('Total Discounted Revenue: 54150')
    end

    it 'shows a link to the bulk discount show page for each eligible item' do
      bd1 = @merch1.bulk_discounts.create(percentage_discount: 8, quantity: 20)
      bd2 = @merch1.bulk_discounts.create(percentage_discount: 5, quantity: 10)

      visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"
      save_and_open_page
      within "#invoice-item-#{@item2.id}" do
        click_link('5% Discount')
      end

      expect(current_path).to eq merchant_bulk_discount_path(merchant_id: @merch1.id, id: bd2.id)

      visit "/merchants/#{@merch1.id}/invoices/#{@invoice1.id}"

      within "#invoice-item-#{@item3.id}" do
        click_link('8% Discount')
      end

      expect(current_path).to eq merchant_bulk_discount_path(merchant_id: @merch1.id, id: bd1.id)
    end
  end
end
