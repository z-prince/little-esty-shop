class HolidayFacade
  def service
    HolidayService.new
  end

  def all_holidays
    service.holiday_data.map { |data| Holiday.new(data) }
  end

  def next_three_holidays
    the_three = []
    upcoming = all_holidays.find_all { |holiday| holiday.date > Date.today.to_s }
    3.times do
      the_three << upcoming.shift
    end
    the_three
  end
end
