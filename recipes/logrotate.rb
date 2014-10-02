Capistrano::Configuration.instance(true).load do

  namespace :logrotate do
    desc "Configures logrotate for the application"
    task :configure, :roles => [:app, :web] do
      
      _cset :log_directory, 'log'

      generated = render('logrotate', binding)
      puts generated
      put generated, "#{application}"
      sudo "mv #{application} /etc/logrotate.d/#{application}"
      sudo "chown root:root /etc/logrotate.d/#{application}"
      sudo "chmod 644 /etc/logrotate.d/#{application}"
    end

    desc "Configure logrotate for high traffic apps on EC2"
    task :configure_ec2_performance, :roles => [:app, :web] do
      _cset :log_directory, 'log'

      sudo "mkdir -p /mnt/archived_logs/#{application}"
      sudo "chown -R  #{user}:#{user} /mnt/archived_logs"
      generated = render('logrotate_ec2', binding)
      puts generated
      put generated, "#{application}"
      sudo "mv #{application} /etc/logrotate.d/#{application}"
      sudo "chown root:root /etc/logrotate.d/#{application}"
      sudo "chmod 644 /etc/logrotate.d/#{application}"
    end

  desc "Move log directory to /mnt"
  task :move_log_dir_to_mnt do
    sudo "mkdir -p /mnt/application_logs/#{application}"
    sudo "chown -R #{user}:#{user} /mnt/application_logs/#{application}"
    sudo "mv /var/www/apps/#{application}/shared/log/ /mnt/application_logs/#{application}"
    sudo "ln -s /mnt/application_logs/#{application} /var/www/apps/#{application}/shared/log"
    # Now need to deploy the app.
  end

  end

end
