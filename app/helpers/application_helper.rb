module ApplicationHelper
  
  def hckr_logo
    content_tag :span, :class => 'hckr_logo' do
      (content_tag :strong, 'eat') + 'hckr'
    end
  end
  
  def drop_down_times
    ((5..23).to_a + (0..4).to_a).map{ |h|
      0.step(59, 30).map{ |m| Time.parse("#{h}:#{m}").to_s }
    }.flatten
  end
  
  def event_select_time(edge, event)
    content_tag(:li, :class => 'select required', :id => "event_#{edge}_input") do 
      content_tag(:label, :for => "event_#{edge}") { edge.humanize } +
        select('event', edge, options_for_select(drop_down_times, event.read_attribute(edge).to_s))
    end
  end
  
  def user_data
    if current_user
      obj = current_user.user_data
      obj[:signedIn] = true
      obj.to_json
    else
      {}.to_json
    end
  end
  
end
