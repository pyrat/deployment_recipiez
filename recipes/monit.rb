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
end