require 'fileutils'

namespace :mapit do
  include FileUtils
  
  task :setup do
    raise "This task should be run from within a Rails application." unless File.exist?('public')
    raise "Already found public/javascripts/mapit.js. Have you already run this task?." if File.exist?('public/javascripts/mapit.js')
    
    cp(File.join(File.dirname(__FILE__), *%w[.. assets javascript mapit.js]), 
        "public/javascripts/mapit.js")
  end  
  
end