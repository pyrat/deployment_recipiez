namespace :monit do
  
  desc "configures monit for nginx"
  task :nginx, :roles => :web do
    put render('nginx_monit', binding), "nginx.conf"
    sudo "mv nginx.conf /etc/monit/conf.d/nginx.conf"
    sudo "/etc/init.d/monit restart"
  end
  
  desc "configures monit for thin"
  task :thin, :roles => :web do
    put render('thin_monit', binding), "#{application}.conf"
    sudo "mv #{application}.conf /etc/monit/conf.d/#{application}.conf"
    sudo "/etc/init.d/monit restart"
  end
  
  desc "configures monit for apache"
  task :apache, :roles => :web do
    put render('apache_monit', binding), "apache_monit.conf"
    sudo "mv apache_monit.conf /etc/monit/conf.d/apache_monit.conf"
    sudo "/etc/init.d/monit restart"
  end
  
  desc "configures monit for mysql"
  task :mysql, :roles => :db do
    put render("mysql_monit", binding), "mysql_monit.conf"
    sudo "mv mysql_monit.conf /etc/monit/conf.d/mysql_monit.conf"
    sudo "/etc/init.d/monit restart"
  end
  
  desc "configures monit for mysql"
  task :sshd, :roles => :web do
    put render("sshd_monit", binding), "sshd_monit.conf"
    sudo "mv sshd_monit.conf /etc/monit/conf.d/sshd_monit.conf"
    sudo "/etc/init.d/monit restart"
  end
  
  task :configure, :roles => :web do
    put render("monit_config", binding), 'monitrc'
    sudo "mv monitrc /etc/monit/monitrc"
    sudo "chown root:root /etc/monit/monitrc"
    sudo "/etc/init.d/monit restart"
  end
  
  
end