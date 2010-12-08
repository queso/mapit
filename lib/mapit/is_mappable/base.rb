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
        Array.class_eval do
          
          def to_markers
            set_letters
            collect {|item| item.to_marker unless item.blank?}
          end
          
          def set_letters
            letter = "A"
            each do |item|
              item.letter = letter if item.respond_to?(:letter)
              letter = letter.succ
            end
          end
          
        end
      end
      
      module InstanceMethods
        attr_accessor :letter
        
        def to_marker
          return nil if self.send(mapit_config.lat_column).zero? && self.send(mapit_config.lng_column).zero?
          if self.respond_to?(:letter)
            {:letter => self.letter, :info => self.send(mapit_config.info_method), :latitude => self.send(mapit_config.lat_column), :longitude => self.send(mapit_config.lng_column), :id => self.id}
          else
            {:info => self.send(mapit_config.info_method), :latitude => self.send(mapit_config.lat_column), :longitude => self.send(mapit_config.lng_column), :id => self.id}
          end
        end
        
      end
      
    end
    
  end
  
end

::ActiveRecord::Base.send :include, MapIt::IsMappable::Base