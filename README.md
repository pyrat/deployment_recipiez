# Deployment Recipiez

A collection of capistrano recipes for doing a whole host of things to servers.

* Apache vhosts
* Logrotate
* Monit
* Nginx Vhost
* Database syncing
* Rsyncing
* Chef
* Php Vhost
* Thin Setup
* Node js deployment
* Foreman Upstart Functionality
* Golang deployment

## Installation

This is released as a gem on rubygems.org. 

    gem install recipiez
    
In your capistrano deploy.rb

    require 'recipiez/capistrano'

Now you will have access to all the cool recipies that I use on a daily basis.


## Bundler

Often even in non-ruby projects I use Bundler when running capistrano. Add this to your Gemfile

gem 'recipiez', :require => false
