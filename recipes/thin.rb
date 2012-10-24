Capistrano::Configuration.instance(true).load do

  namespace :thin do

    desc "configures thin, requires num_servers and start_port"
    task :configure, :roles => :app do
      sudo "thin config -C /etc/thin/#{application}.yml -c #{current_path}  --servers #{num_servers} -e #{rails_env} --port #{start_port}"
    end

    desc "configures thin with rackup eg. Sinatra. Requires thin_port, rack_env"
    task :configure_rack, :roles => :app do
      sudo "thin config -C /etc/thin/#{application}.yml -c #{current_path} --servers #{num_servers} --port #{start_port} -e #{rack_env} -R #{current_path}/config.ru"
    end

    desc "install thin"
    task :install, :roles => :app do
      sudo "gem install thin"
      sudo "thin install"
      sudo "/usr/sbin/update-rc.d -f thin defaults"
    end

    desc "start thin"
    task :start, :roles => :app do
      sudo "/etc/init.d/thin start"
      sudo "/usr/bin/ruby /usr/bin/thin start -C /etc/thin/#{application}.yml"
    end

    desc "stop thin"
    task :stop, :roles => :app do
      sudo "/usr/bin/ruby /usr/bin/thin stop -C /etc/thin/#{application}.yml"
    end

    desc "restart thin"
    task :restart, :roles => :app do
      sudo "/usr/bin/ruby /usr/bin/thin restart -C /etc/thin/#{application}.yml"
    end
    
    desc "setup thin install and loads of other goodies, one stop shop!"
    task :setup, :roles => :app do
      recipiez::setup
      nginx::configure
      logrotate::configure
      recipiez::bundler
      recipiez::libxml
      thin::install
      thin::configure
      monit::thin
    end

  end
end
