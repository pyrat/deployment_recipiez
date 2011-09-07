namespace :chef do
  
  desc "Runs chef client on all the app servers"
  task :client do
    sudo "chef-client"
  end
  
end