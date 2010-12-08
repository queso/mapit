module MapIt

  # This class is not intended to be used on its own, it is used internally
  # by `is_mappable` to store a model's configuration and
  # configuration-related methods.
  #
  # The arguments accepted by +is_mappable+ correspond to the writeable
  # instance attributes of this class; please see the description of the
  # attributes below for information on the possible options.
  #
  # @example
  # is_mappable :lat_column => :lat,
  #  :lng_column => :lng,
  #  :info_method => :name
  #  # etc.
  class Configuration

    DEFAULTS = {
      :lat_column                 => :latitude,
      :lng_column                 => :longitude,
      :info_method                => :name
    }

    # Strip diacritics from Western characters.
    attr_accessor :lat_column, :lng_column, :info_method
    
    def initialize(configured_class, options = nil)
      @configured_class = configured_class
      DEFAULTS.merge(options || {}).each do |key, value|
        self.send "#{key}=".to_sym, value
      end
    end
    
  end
  
end