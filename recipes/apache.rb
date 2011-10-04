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

      unless defined? apache_port
        set :apache_port, '80'
      end
      
      unless defined? allowed_ips
        set :allowed_ips, []
      end

      logger.info "generating .conf file"
      logger.info "placing #{application}.conf on remote server"
      apache_conf = "/etc/apache2/sites-available/#{application}"
      put render("php_vhost", binding), "#{application}.conf"
      sudo "mv #{application}.conf #{apache_conf}"
      sudo "a2ensite #{application}"
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
