# Include hook code here
require File.dirname(__FILE__) + "/../app/helpers/mapit_helper"
require 'mapit'
ActionView::Base.send :include, MapItHelper
