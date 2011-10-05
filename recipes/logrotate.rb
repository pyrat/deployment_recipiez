Capistrano::Configuration.instance(true).load do

  namespace :logrotate do
    desc "Configures logrotate for the application"
    task :configure, :roles => :app do

      unless exists? :log_directory
        set :log_directory, 'log'
      end

      generated = render('logrotate', binding)
      puts generated
      put generated, "#{application}"
      sudo "mv #{application} /etc/logrotate.d/#{application}"
    end
  end

end
