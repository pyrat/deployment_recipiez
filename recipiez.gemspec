# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
 
Gem::Specification.new do |s|
  s.name        = "recipiez"
  s.version     = "0.0.9"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alastair Brunton"]
  s.email       = ["info@simplyexcited.co.uk"]
  s.homepage    = "http://github.com/pyrat/deployment_recipiez"
  s.summary     = "Collection of capistrano recipies which do good things."
  s.description = "DB Syncing, Logrotate, Apache, Thin, Basecamp, Activecollab, Monit"
  
  s.add_dependency('xml-simple')
  s.add_dependency('mechanize')
  
  s.required_rubygems_version = ">= 1.3.1"
  s.require_path = 'lib'
  s.files       = `git ls-files`.split("\n")
end