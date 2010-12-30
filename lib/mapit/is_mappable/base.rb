module MapIt
  
  module IsMappable
  
    module Base
      
      def self.included(base)
        base.extend(Config)
      end
      
      module Config
        
        def is_mappable(options = {})
          class_inheritable_accessor :mapit_config
          write_inheritable_attribute :mapit_config, Configuration.new(self, options)
          class_eval do
            extend MapIt::IsMappable::Base::ClassMethods
          end
          include MapIt::IsMappable::Base::InstanceMethods
        end
        
      end
      
      module ClassMethods
        
        def group_by_lat_lng(marker, markers)
          markers.select do |marker_to_match|
            (marker_to_match.send(mapit_config.lat_column) == marker.send(mapit_config.lat_column)) && (marker_to_match.send(mapit_config.lng_column) == marker.send(mapit_config.lng_column))
          end
        end
        
        def collect_duplicate_info(original_markers, joiner)
          return if original_markers.size <= 1
          markers = original_markers.dup
          new_info = markers.collect {|m| m.send(mapit_config.info_method)}
          overide = new_info.flatten.join(joiner)
          markers.each {|m| m.mapit_info_overide = overide}
          return true
        end
        
        Array.class_eval do
          
          def to_markers
            set_letters
            collect {|item| item.to_marker unless item.blank?}
          end
          
          def to_unique_markers(options = {})
            options[:joiner] ||= ", "
            grouped_markers = collect {|marker| marker.class.group_by_lat_lng(marker, self)}.uniq
            set_duplicate_letters(grouped_markers)
            grouped_markers.each {|markers| markers.first.class.collect_duplicate_info(markers, options[:joiner])}
            grouped_markers.collect {|markers| to_marker_with_combined_info(markers)}.flatten
          end
          
          def to_marker_with_combined_info(markers)
            markers.collect do |marker|
              marker.to_marker(true)
            end
          end
          
          def set_letters
            letter = "A"
            each do |item|
              item.letter = letter
              letter = letter.succ
            end
          end
          
          def set_duplicate_letters(grouped_markers)
            letter = "A"
            grouped_markers.each do |markers|
              markers.each {|marker| marker.letter = letter}
              letter = letter.succ
            end
          end
          
        end
      end
      
      module InstanceMethods
        attr_accessor :letter
        attr_accessor :mapit_info_overide
        
        def to_marker(overide = false)
          return nil if self.send(mapit_config.lat_column).to_f.zero? && self.send(mapit_config.lng_column).to_f.zero?
          if overide && self.mapit_info_overide
            info = mapit_info_overide
          else
            info = self.send(mapit_config.info_method)
          end
          {:letter => self.letter, :info => info, :latitude => self.send(mapit_config.lat_column), :longitude => self.send(mapit_config.lng_column), :id => self.id}
        end
        
      end
      
    end
    
  end
  
end

::ActiveRecord::Base.send :include, MapIt::IsMappable::Base