Capistrano::Configuration.instance(true).load do

  namespace :node do

    desc "Generates upstart file for the application"
    task :generate_upstart do
      unless exists? :node_env
        set :node_env, 'development'
      end
      
      put render("upstart", binding), "#{application}.conf"
      sudo "mv #{application}.conf /etc/init/#{application}.conf"
    end
    
    desc "Install the nodejs components to the server"
    task :setup do
      recipiez::setup
      nginx::nodejs
      node::generate_upstart
      monit::node
      logrotate::configure
    end

  end
  
  
  namespace :npm do
    task :install do
      run "cd #{release_path} && npm install"
    end
  end
  

end
