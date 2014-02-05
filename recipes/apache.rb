Capistrano::Configuration.instance(true).load do

  namespace :apache do

    desc "Setup passenger vhost"
    task :passenger_vhost do
      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}"
      put render("passenger_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "a2ensite #{application}"
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


      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}"
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
      apache_conf = "/etc/apache2/sites-available/#{application}"
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


  end

end
