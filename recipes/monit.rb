Capistrano::Configuration.instance(true).load do

  namespace :monit do

    desc "configures monit for nginx"
    task :nginx, :roles => :web do
      put render('nginx_monit', binding), "nginx.conf"
      sudo "mv nginx.conf /etc/monit/conf.d/nginx.conf"
      sudo "/etc/init.d/monit restart"
    end
    
    
    # /usr/local/sbin/spawner.sh
    desc "configures monit for thin"
    task :thin, :roles => :web do
      put render('spawner_monit', binding), "spawner.sh"
      run "chmod +x spawner.sh"
      sudo "mv spawner.sh /usr/local/sbin/spawner.sh"
      
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
    
    desc "configures monit for node"
    task :node, :roles => :web do
      put render('node_monit', binding), "node_monit.conf"
      sudo "mv node_monit.conf /etc/monit/conf.d/node_monit_#{application}.conf"
      sudo "/etc/init.d/monit restart"
    end

    desc "configures monit for go"
    task :go, :roles => :web do
      put render('go_monit', binding), "go_monit.conf"
      sudo "mv go_monit.conf /etc/monit/conf.d/go_monit_#{application}.conf"
      sudo "/etc/init.d/monit restart"
    end


  end

end
