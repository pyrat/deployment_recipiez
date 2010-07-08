namespace :monit do
  
  desc "configures monit for nginx"
  task :nginx, :roles => :web do
    puts render('nginx_monit', binding)
  end
  
  
  desc "configures monit for thin"
  task :thin, :roles => :web do
    
  end
end