# A class to update basecamp after a successful deployment
require 'basecamp'
class BasecampNotifier

  def initialize(application, rails_env, options = {}, current_rev = 0, rev_log = '')
    
    if keys_missing?(options)
      raise StandardError, 'You have not supplied all arguments in the hash (:username, :password, :domain, :category_id, :project_id)'
    end
    
    @project_id = options[:project_id]
    @category_id = options[:category_id]
    @current_revision = current_rev
    @application = application
    @rails_env = rails_env
    @revision_log = rev_log
    @basecamp = Basecamp.new(options[:domain], options[:username], options[:password], true)
  end
  
  def keys_missing?(options)
    [:domain, :username, :password, :category_id, :project_id].each do |key|
      return true unless options.has_key?(key)
    end
    false
  end

  def notify
    message = {:title => "#{@application} rev. #{@current_revision} deployed to #{@rails_env}",
      :body => "#{@application} has been successfully deployed to #{@rails_env} <br /> #{@revision_log}",
    :category_id => @category_id}
    @basecamp.post_message(@project_id, message)
  end

end
