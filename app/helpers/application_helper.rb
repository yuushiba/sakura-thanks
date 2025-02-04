module ApplicationHelper
  def type_to_alert_class(type)
    case type.to_sym
    when :success
      "alert-success"
    when :danger, :error
      "alert-error"
    when :warning
      "alert-warning"
    when :info
      "alert-info"
    else
      "alert-info"
    end
  end
end
