module MapItHelper
  
  def javascript_mapit_include
    js = '<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>'
    js += javascript_include_tag 'mapit'
    js
  end
  
  def add_map(div, points, options = {})
    points = points.to_markers unless points.first.class == Hash
    content_for :map do
      <<-END
        <script type="text/javascript">
          var map_points = #{points.compact.to_json};
          addLoadEvent( function () { buildMapIt("#{div}", map_points, ""); });
        </script>
      END
    end
  end
  
end
