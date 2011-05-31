require 'mechanize'

module ActiveCollab

  class Notifier

    def initialize(options = {})
      
      if keys_missing?(options)
        raise StandardError, "You have not supplied all the required arguments in the hash. (base_url, project_id, ticket_id, email, password)"
      end
      
      @base_url = options[:base_url]
      @project_id = options[:project_id]
      @ticket_id = options[:ticket_id]
      @mech = Mechanize.new
      @email = options[:email]
      @password = options[:password]
    end

    def say(message)
      login
      submit_ticket_comment(message)
    end
    
    def keys_missing?(options)
      [:base_url, :project_id, :ticket_id, :email, :password].each do |key|
        return true unless options.has_key?(key)
      end
      false
    end
    
    private
    
    def login
            
      @mech.get(@base_url + "/login") do |login_page|
        form = login_page.forms.first
        
        form['login[email]'] = @email
        form['login[password]'] = @password
        
        form.click_button
      end
    end
    
    def submit_ticket_comment(message)
      @mech.get(@base_url + "/projects/#{@project_id}/tickets/#{@ticket_id}") do |page|
        page.form_with(:action => /\/projects\/#{@project_id}\/comments\/add/) do |comment_form|
          comment_form['comment[body]'] = message
          comment_form.click_button
        end
      end
    end

  end

end
