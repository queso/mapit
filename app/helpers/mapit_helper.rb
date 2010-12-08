module MapItHelper
  
  def add_map(div, points, options = {})
    points = points.to_markers unless points.compact.first.class == Hash
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
    link_to text, "http://maps.google.com/maps?saddr=&daddr=#{end_point.latitude},#{end_point.longitude}", options
  end
  
  def google_directions_form(label, end_point, options = {})
    form_tag("http://maps.google.com/maps", :method => :get) do
      hidden_field_tag(:daddr, "#{end_point.latitude}, #{end_point.longitude}") +
      text_field_tag(:saddr) + 
      submit_tag(label)
    end
  end
  
end
