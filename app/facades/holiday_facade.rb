class HolidayFacade
  def service
    HolidayService.new
  end

  def all_holidays
    service.holiday_data.map { |data| Holiday.new(data) }
  end
end
