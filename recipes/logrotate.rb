namespace :logrotate do
  desc "Configures logrotate for the application"
  task :configure, :roles => :app do
    generated = render('logrotate', binding)
    puts generated
    put generated, "#{application}"
    sudo "mv #{application} /etc/logrotate.d/#{application}"
  end
end