namespace :thin do
  
  desc "configures thin, requires num_servers and start_port"
  task :configure, :roles => :app do
    sudo "thin config -C /etc/thin/#{application}.yml -c #{current_path}  --servers #{num_servers} -e #{rails_env} --port #{start_port}"
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
  end
  
  desc "start thin"
  task :stop, :roles => :app do
    sudo "/etc/init.d/thin stop"
  end
  
  desc "restart thin" 
  task :restart, :roles => :app do
    sudo "/etc/init.d/thin restart"
  end

  
end
