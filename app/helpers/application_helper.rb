module ApplicationHelper
  def type_to_alert_class(type)
    case type.to_sym
    when :success
      'bg-[#36D399]'  # 緑色
    when :danger
      'bg-[#F87272]'  # 赤色
    when :warning
      'bg-[#FBBD23]'  # 黄色
    else
      'bg-[#3ABFF8]'  # 青色
    end
  end
end
