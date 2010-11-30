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
  
end
