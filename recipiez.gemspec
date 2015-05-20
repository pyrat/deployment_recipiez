# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'recipiez/version'

 
Gem::Specification.new do |s|
  s.name        = "recipiez"
  s.version     = Recipiez::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alastair Brunton"]
  s.email       = ["info@simplyexcited.co.uk"]
  s.homepage    = "http://github.com/pyrat/deployment_recipiez"
  s.summary     = "Capistrano recipies for DB Syncing, Logrotate, Apache, Thin, Basecamp, Activecollab, Monit, NodeJS, Nginx"
  s.description = "Capistrano recipies for DB Syncing, Logrotate, Apache, Thin, Basecamp, Activecollab, Monit, NodeJS, Nginx"

  s.license = 'MIT'
  s.add_dependency('tinder')
  s.add_dependency('travis')
    
  s.required_rubygems_version = ">= 1.3.1"
  s.require_path = 'lib'
  s.files       = `git ls-files`.split("\n")
end
