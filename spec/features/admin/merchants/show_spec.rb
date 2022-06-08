require 'rails_helper'

RSpec.describe 'admin merchant show page' do
  it 'shows the name of the merchant', :vcr do
    @merch1 = Merchant.create!(name: 'Floopy Fopperations')

    visit admin_merchant_path(@merch1)

    expect(page).to have_content('Name: Floopy Fopperations')
  end

  it 'can update the merchant', :vcr do
    @merch1 = Merchant.create!(name: 'Floopy Fopperations')

    visit admin_merchant_path(@merch1)

    click_link('Update Merchant')

    expect(current_path).to eq(edit_admin_merchant_path(@merch1))

    fill_in 'Name', with: 'Cherry Chidona'

    click_on('Save')

    expect(current_path).to eq(admin_merchant_path(@merch1))

    expect(page).to have_content('Merchant has been successfully updated!')

    expect(page).to have_content('Name: Cherry Chidona')

    expect(page).to_not have_content('Name: Floopy Fopperations')
  end
end
