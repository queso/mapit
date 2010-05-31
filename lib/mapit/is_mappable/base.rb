module MapIt
  
  module IsMappable
  
    module Base
      
      def self.included(base)
        base.extend(Config)
      end
      
      module Config
        
        def is_mappable
          class_eval do
            extend MapIt::IsMappable::Base::ClassMethods
          end
          include MapIt::IsMappable::Base::InstanceMethods
        end
        
      end
      
      module ClassMethods
        Array.class_eval do
          
          def to_markers
            collect {|item| item.to_marker}
          end
          
        end
      end
      
      module InstanceMethods
        
        def to_marker
          {:info => self.address, :latitude => self.latitude, :longitude => self.longitude}
        end
        
      end
      
    end
    
  end
  
end

::ActiveRecord::Base.send :include, MapIt::IsMappable::Base