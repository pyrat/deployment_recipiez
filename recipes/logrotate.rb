Capistrano::Configuration.instance(true).load do

  namespace :logrotate do
    desc "Configures logrotate for the application"
    task :configure, :roles => [:app, :web] do
      
      _cset :log_directory, 'log'

      generated = render('logrotate', binding)
      puts generated
      put generated, "#{application}"
      sudo "mv #{application} /etc/logrotate.d/#{application}"
    end

    desc "Configure logrotate for high traffic apps on EC2"
    task :configure_ec2_performance, :roles => [:app, :web] do
      _cset :log_directory, 'log'

      # create the directory and chown in mnt TODO
      sudo "mkdir -p /mnt/archived_logs/#{application}"
      sudo "chown -R  #{user}:#{user} /mnt/archived_logs"
      generated = render('logrotate_ec2', binding)
      puts generated
      put generated, "#{application}"
      sudo "mv #{application} /etc/logrotate.d/#{application}"
    end
  end

end
