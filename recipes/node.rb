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
    

  end

end
