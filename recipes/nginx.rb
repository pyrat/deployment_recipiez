namespace :nginx do
  desc "configures a vhost for the app, needs - num_servers, start_port"
  task :configure, :roles => :web do
    put render("nginx_vhost", binding), "#{application}.conf"
    sudo "mv #{application}.conf /etc/nginx/sites-available/#{application}.conf"
    sudo "ln -s /etc/nginx/sites-available/#{application}.conf /etc/nginx/sites-enabled/#{application}.conf"
    stop
    start
  end
  
  desc "Starts Nginx webserver"
  task :start, :roles => :web do
    sudo "/etc/init.d/nginx start"
  end

  desc "Stops Nginx webserver"
  task :stop, :roles => :web do
    sudo "/etc/init.d/nginx stop"
  end
  
end