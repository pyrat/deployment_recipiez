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

     unless apache_port
       set :apache_port, '80'
     end

     logger.info "generating .conf file"
     logger.info "placing #{application}.conf on remote server"
     apache_conf = "/etc/apache2/sites-available/#{application}"
     put render("php_vhost", binding), "#{application}.conf"
     sudo "mv #{application}.conf #{apache_conf}"
     sudo "a2ensite #{application}"
     sudo "/etc/init.d/apache2 reload"
   end
  
  
  
end