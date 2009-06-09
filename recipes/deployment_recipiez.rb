$LOAD_PATH << File.dirname(__FILE__) + '/../lib'
require 'basecamp_notifier'

# A collection of reusable deployment tasks.
# Hook them into your deploy script with the *after* function.
# Author: Alastair Brunton


namespace :recipiez do

  desc "Rename db file for deployment."
  task :rename_db_file do
    run "cp #{release_path}/config/database.#{rails_env} #{release_path}/config/database.yml"
  end
  
  desc "Rename db file for deployment."
  task :rename_settings_file do
    run "cp #{release_path}/config/settings.yml.#{rails_env} #{release_path}/config/settings.yml"
  end
  
  # You need to add the below line to your deploy.rb
  # set :basecamp_auth, {:username => 'robot', :domain => 'ifo.projectpath.com',
  #                         :password => 'robot', :project_id => 828898,
  #                         :category_id => 15509}
  desc "Update basecamp with information of the deployment."
  task :update_basecamp do
    basecamp_notifier = BasecampNotifier.new(application, rails_env,
    basecamp_auth, current_revision, get_rev_log)
    basecamp_notifier.notify
  end

  desc "This gets the revision log - svn only at the moment"
  task :get_rev_log do
    grab_revision_log
  end
  
  desc "Restart passenger application instance"
  task :restart_passenger do
    run "touch #{current_release}/tmp/restart.txt"
  end
  
  desc "Upload contents of local system dir"
  task :upload_system do
    puts "Uploading system directory.."
    system "rsync -vr --exclude='.DS_Store' -e \"ssh -p #{ssh_options[:port]}\" public/system #{user}@#{domain}:#{shared_path}/"
  end

  desc "Restart mongrel."
  task :single_mongrel_restart do
    use_sudo == true ? command = "sudo" : command = "run"
    begin
      eval("#{command} \"mongrel_rails stop -c #{release_path}\"")
    rescue
      puts "**** Error ******: Problem stopping mongrel."
    end
    run "sleep 3"
    eval("#{command} \"mongrel_rails start -c #{release_path} -e #{rails_env} -p #{mongrel_port} -d\"")
  end

  desc "Stop the nginx webserver."
  task :nginx_stop do
    sudo '/etc/init.d/nginx stop'
  end

  desc "Start the nginx webserver"
  task :nginx_start do
    sudo '/etc/init.d/nginx start'
  end

  desc "Restart the nginx webserver"
  task :nginx_restart do
    nginx_stop
    nginx_start
  end

  desc "Change permissions for apache cgi"
  task :change_public_perms do
    run "chmod -R 755 #{release_path}/public"
  end

  desc "Restart lighttpd"
  task :lighttpd_restart do
    run "#{lighttpd_ctl_path} restart &"
  end


  desc "Dump database, copy it across and restore locally."
  task :dump_and_copy_and_restore_db do
    archive = generate_archive(application)
    filename = get_filename(application)
    cmd = "mysqldump --opt --skip-add-locks -u #{db_user} "
    cmd += " -p#{db_password} "
    cmd += "#{database_to_dump} > #{archive}"
    result = run(cmd)

    cmd = "rsync -av -e \"ssh -p #{ssh_options[:port]}\" #{user}@#{roles[:db].servers.first}:#{archive} #{dump_dir}#{filename}"
    puts "running #{cmd}"
    result = system(cmd)
    puts result
    run "rm #{archive}"

    `cat #{dump_dir}#{get_filename(application)} | mysql -u#{db_local_user} -p#{db_local_password} #{db_dev}`
  end

  desc "Tar up the shared system dir and copy it across"
  task :rsync_system_dir do
    `rsync -av -e \"ssh -p #{ssh_options[:port]}\" #{user}@#{roles[:db].servers.first}:#{shared_path}/system/ public/system/`
  end

  desc "Sync with database and files"
  task :sync_remote do
    dump_and_copy_and_restore_db
    rsync_system_dir
  end

end

namespace :deploy do
  task :restart do
    # override this task
  end
end



def generate_archive(name)
  '/tmp/' + get_filename(name)
end

def get_filename(name)
  name.sub('_', '.') + '.sql'
end


def grab_revision_log
  case scm.to_sym
  when :git
    %x( git log --pretty=format:"* #{"[%h, %an] %s"}" #{previous_revision}..#{current_revision} )
  when :subversion
    format_svn_log current_revision, previous_revision
  end
end

def format_svn_log(current_revision, previous_revision)
  # Using REXML as it comes bundled with Ruby, would love to use Hpricot.
  # <logentry revision="2176">
  # <author>jgoebel</author>
  # <date>2006-09-17T02:38:48.040529Z</date>
  # <msg>add delete link</msg>
  # </logentry>
  require 'rexml/document'
  begin
    xml = REXML::Document.new(%x( svn log --xml --revision #{current_revision}:#{previous_revision} ))
    xml.elements.collect('//logentry') do |logentry|
      "* [#{logentry.attributes['revision']}, #{logentry.elements['author'].text}] #{logentry.elements['msg'].text}"
    end.join("\n")
  rescue
    %x( svn log --revision #{current_revision}:#{previous_revision} )
  end
end
