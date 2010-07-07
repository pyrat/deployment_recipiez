namespace :thin do
  
  desc "configures thin, requires num_servers and start_port"
  task :configure, :roles => :app do
    sudo "thin config -C /etc/thin/#{application}.yml -c #{current_path}  --servers #{num_servers} -e #{rails_env} --port #{start_port}"
  end
  
  desc "configures thin with rackup eg. Sinatra. Requires thin_port"
  task :configure_rack, :roles => :app do
    sudo "thin config -C /etc/thin/#{application}.yml -c #{current_path} --servers 1 --port #{thin_port} -R #{current_path}/config.ru"
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

  
end
