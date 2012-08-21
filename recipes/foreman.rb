Capistrano::Configuration.instance(true).load do
  namespace :foreman do
    desc "Export the Procfile to Ubuntu's upstart scripts"
    task :export, roles => :app do
      run "cd #{release_path} && sudo bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{shared_path}/log -e foreman.env"
    end

    desc "Start the application services"
    task :start, roles => :app do
      sudo "service #{application} start"
    end

    desc "Stop the application services"
    task :stop, roles => :app do
      sudo "service #{application} stop"
    end

    desc "Restart the application services"
    task :restart, roles => :app do
      run "sudo service #{application} start || sudo service #{application} restart"
    end
    
    desc "Rename Procfile for deployment."
    task :rename_env_file do
      run "cp #{release_path}/foreman.env.#{rails_env} #{release_path}/foreman.env"
    end
    
  end
end
