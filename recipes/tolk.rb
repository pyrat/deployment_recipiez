namespace :tolk do
  
  desc "Runs tolk:sync on the remove server. Useful for when you update"
  task :sync do
    run "cd #{current_path};rake tolk:sync RAILS_ENV=#{rails_env}"
  end
  
  desc "Runs tolk:dump_all on the remove server. Useful for when you update"
  task :dump_all do
    run "cd #{current_path};rake tolk:dump_all RAILS_ENV=#{rails_env}"
  end
  
end