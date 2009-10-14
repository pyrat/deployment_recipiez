namespace :thin do
  
  desc "configures thin"
  task :configure, :roles => :app do
    sudo "thin config -C /etc/thin/#{application}.yml -c #{current_path}  --servers #{thin_servers} -e #{rails_env}"
  end
  
  desc "start thin"
  task :start, :roles => :app do
    sudo "/etc/init.d/thin start"
  end
  
  desc "start thin"
  task :stop, :roles => :app do
    sudo "/etc/init.d/thin stop"
  end
  
  desc "restart thin" do
    sudo "/etc/init.d/thin restart"
  end

  
end
