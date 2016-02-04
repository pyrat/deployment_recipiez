Capistrano::Configuration.instance(true).load do
  namespace :nginx do
    desc "configures a vhost for the app, needs - num_servers, start_port"
    task :configure, :roles => :web do
      put render("nginx_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf /etc/nginx/sites-available/#{application}.conf"
      begin
        sudo "ln -s /etc/nginx/sites-available/#{application}.conf /etc/nginx/sites-enabled/#{application}.conf"
      rescue
        # do nothing
      end

      begin
        stop
      rescue
        # do nothing
      end

      begin
        start
      rescue
        # do nothing
      end
    end
    
    
    desc "Generates a simple proxy configuration for a nodejs application"
    task :nodejs do
            
      _cset :node_port, 3000
      _cset :ssl_enabled, false
      
      
      put render("nginx_node", binding), "#{application}.conf"
      sudo "mv #{application}.conf /etc/nginx/sites-available/#{application}.conf"
      begin
        sudo "ln -s /etc/nginx/sites-available/#{application}.conf /etc/nginx/sites-enabled/#{application}.conf"
      rescue
        # do nothing
      end

      begin
        stop
      rescue
        # do nothing
      end

      begin
        start
      rescue
        # do nothing
      end
    end


    desc "Generates a simple proxy configuration for a golang application"
    task :golang do
            
      _cset :go_port, 3000
      _cset :ssl_enabled, false
      
      
      put render("nginx_golang", binding), "#{application}.conf"
      sudo "mv #{application}.conf /etc/nginx/sites-available/#{application}.conf"
      begin
        sudo "ln -s /etc/nginx/sites-available/#{application}.conf /etc/nginx/sites-enabled/#{application}.conf"
      rescue
        # do nothing
      end

      begin
        stop
      rescue
        # do nothing
      end

      begin
        start
      rescue
        # do nothing
      end
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
end
