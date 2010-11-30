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
        
        def to_marker
          return nil if self.latitude.zero? && self.longitude.zero?
          if self.respond_to?(:letter)
            {:letter => self.letter, :info => self.address, :latitude => self.latitude, :longitude => self.longitude, :id => self.id}
          else
            {:info => self.address, :latitude => self.latitude, :longitude => self.longitude, :id => self.id}
          end
        end
        
      end
      
    end
    
  end
  
end

::ActiveRecord::Base.send :include, MapIt::IsMappable::Base