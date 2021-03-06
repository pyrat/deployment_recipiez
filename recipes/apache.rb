Capistrano::Configuration.instance(true).load do

  namespace :apache do

    desc "Setup passenger vhost"
    task :passenger_vhost do
      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}.conf"
      put render("passenger_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "a2ensite #{application}.conf"
      sudo "/etc/init.d/apache2 reload"
    end

    desc "Setup passenger elb vhost with HTTPS redirect (http internally)"
    task :passenger_elb_vhost do
      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}.conf"
      put render("passenger_elb_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "a2ensite #{application}.conf"
      sudo "/etc/init.d/apache2 reload"
    end



    desc "PHP Vhost Setup"
    task :php_vhost do

      _cset :apache_port, '80'
      _cset :allowed_ips, []
      _cset :server_aliases, []
      _cset :ssl_chain, 'none'
      _cset :custom_vars, {}

      unless exists? :ssl
        set :ssl, 'off'
      end
      
      unless exists? :ssl_redirect_elb
        set :ssl_redirect_elb, "off"
      end


      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}.conf"
      put render("php_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "a2ensite #{application}"
      sudo "/etc/init.d/apache2 reload"
    end

    desc "PHP Secure Vhost Setup"
    task :secure_php_vhost do

      _cset :allowed_ips, []
      _cset :ssl_chain, 'none'
      _cset :custom_vars, {}

      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}.conf"
      put render("secure_php_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "a2ensite #{application}"
      sudo "/etc/init.d/apache2 reload"
    end


    desc "Install mongo to php"
    task :mongo_php do
      sudo "apt-get install -y php-pear php5-dev"
      begin
        sudo "pecl install mongo"
      rescue
        puts "Error installing mongo."
      end
      put render("mongo_ini", binding), "mongo_ini"
      sudo "mv mongo_ini /etc/php5/conf.d/mongo.ini"
      sudo "/etc/init.d/apache2 reload"
    end

    desc "enable php"
    task :enable_php do
      put render("php_handler", binding), "phphandler.conf"
      apache_handler = "/etc/apache2/conf.d/phphandler"
      sudo "mv phphandler.conf #{apache_handler}"
      sudo "/etc/init.d/apache2 force-reload"
    end

    desc "upload certs"
    task :upload_certs do
      # this need to upload the certs .tae.gz to the server from a specified location.
      # Upload to /etc/apache2/ssl
      upload(ssl_certs_archive, "certs.tar.gz", :via => :scp)
      sudo "mv certs.tar.gz /etc/apache2/ssl/"
      sudo "cd /etc/apache2/ssl/ && tar zxvf certs.tar.gz"
      puts "All done!"
    end


  end

end
