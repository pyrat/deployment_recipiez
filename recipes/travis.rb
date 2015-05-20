require 'travis/pro'

Capistrano::Configuration.instance(true).load do

    namespace :ci do
      desc "verification of branch build status on Travis CI"
      task :verify do
        begin
          # strip git@github.com: and .git portion
          travis_repo = repository[15..-5]

          Travis::Pro.access_token = travis_key
          repo = Travis::Pro::Repository.find(travis_repo)
          branch_state = repo.branch(branch).state
     
          unless branch_state == "passed"
            Capistrano::CLI.ui.say "Your '#{branch}' branch has '#{branch_state}' state on CI."
            Capistrano::CLI.ui.ask("Continue anyway? (y/N)") == 'y' or abort
          end
        rescue => e
          Capistrano::CLI.ui.say e.message
        end
      end
    end

end