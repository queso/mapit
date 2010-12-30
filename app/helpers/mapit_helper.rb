module MapItHelper
  
  def add_map(div, points, options = {})
    if options[:combine_locations]
      points = points.to_unique_markers(:joiner => options[:joiner]) unless points.compact.first.class == Hash
    else
      points = points.to_markers unless points.compact.first.class == Hash
    end
    content_for :mapit do
      <<-END
        <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
        #{javascript_include_tag 'mapit'}
        <script type="text/javascript">
          var map_points = #{points.compact.to_json};
          addLoadEvent( function () { buildMapIt("#{div}", map_points, #{options.to_json}); });
        </script>
      END
    end
  end
  
  def link_to_infowindow(text, url, id, options = {})
    link_to text, url, options.merge({:onclick => "infoWindow_#{id}(); return false;"})
  end
  
  def link_to_google_directions(text, end_point, options = {})
    marker = end_point.to_marker
    link_to text, "http://maps.google.com/maps?saddr=&daddr=#{marker[:latitude]},#{marker[:longitude]}", options
  end
  
  def google_directions_form(label, end_point, options = {})
    marker = end_point.to_marker
    form_tag("http://maps.google.com/maps", :method => :get) do
      hidden_field_tag(:daddr, "#{marker[:latitude]}, #{marker[:longitude]}") +
      text_field_tag(:saddr) + 
      submit_tag(label)
    end
  end
  
end
