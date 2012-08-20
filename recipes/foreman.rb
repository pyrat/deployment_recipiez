Capistrano::Configuration.instance(true).load do
  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles: :app do
      run "cd #{current_path} && sudo bundle exec foreman export upstart /etc/init -a sites/#{application} -u #{user} -l #{shared_path}/log"
    end

    desc "Start the application services"
    task :start, roles: :app do
      sudo "service sites/#{application} start"
    end

    desc "Stop the application services"
    task :stop, roles: :app do
      sudo "service sites/#{application} stop"
    end

    desc "Restart the application services"
    task :restart, roles: :app do
      run "sudo service sites/#{application} start || sudo service sites/#{application} restart"
    end
  end
end
