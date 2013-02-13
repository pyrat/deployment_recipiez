Capistrano::Configuration.instance(true).load do

  namespace :campfire do
    task :notify do
      campfire = Tinder::Campfire.new campfire_subdomain, :token => campfire_token, :ssl_options => {:verify => false} 
      campfire_room = campfire.find_room_by_id(campfire_room_id)
      announced_deployer = `git config user.name` 
      announced_stage = fetch(:stage, 'production')
      announcement = "#{announced_deployer} has deployed #{application} to #{announced_stage}"
      campfire_room.speak announcement
      begin
        rev_log = %x( git log --pretty=format:"* #{"[%h, %an] %s"}" #{previous_revision}..#{current_revision} )
        campfire_room.paste rev_log
      rescue Faraday::Error::ParsingError
        # FIXME deal with crazy color output instead of rescuing
        # it's stuff like: ^[[0;33m and ^[[0m
        campfire_room.speak "Error pasting log."
      end
    end
  end
 
end

