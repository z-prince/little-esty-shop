class HolidayService
  def get_url(url)
    response = HTTParty.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def holiday_data
    get_url('https://date.nager.at/api/v3/PublicHolidays/2022/US')
  end
end
