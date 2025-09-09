module ApplicationHelper
  def number_to_hours(minutes)
    if minutes.nil?
      return "00:00"
    end
    hours = minutes / 60
    minutes = minutes % 60
    format("%02d:%02d", hours, minutes)
  end
end
