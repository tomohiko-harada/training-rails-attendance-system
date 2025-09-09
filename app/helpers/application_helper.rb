module ApplicationHelper
  def number_to_hours(minutes)
    return '00:00' if minutes.nil?

    hours = minutes / 60
    minutes %= 60
    format('%02d:%02d', hours, minutes)
  end
end
