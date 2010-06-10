$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'active_support'
require 'active_record'
require 'action_view'
require 'spec'
require 'spec/autorun'
require 'mapit'
require File.dirname(__FILE__) + "/../app/helpers/mapit_helper"

Spec::Runner.configure do |config|
  
end
