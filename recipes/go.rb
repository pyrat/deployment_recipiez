Capistrano::Configuration.instance(true).load do

  namespace :go do

    # This configures a go app for deployment for the first time.
    # A one stop shop.
    task :setup do
      desc "This configures a go app for deployment for the first time."
      recipiez::setup
      go::generate_upstart
      monit::go
      logrotate::configure
    end

    task :generate_upstart do
      desc "This generates the process control scripts for go apps."
      unless exists? :go_env
        set :go_env, 'development'
      end
      
      put render("upstart_go", binding), "#{application}.conf"
      sudo "mv #{application}.conf /etc/init/#{application}.conf"



    end




  end




end

