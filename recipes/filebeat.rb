Capistrano::Configuration.instance(true).load do

  namespace :filebeat do

    desc "Install filebeat on remote servers"
    task :install do
      run "echo \"deb https://packages.elastic.co/beats/apt stable main\" |  sudo tee -a /etc/apt/sources.list.d/beats.list"
      run "wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -"
      sudo "apt-get update"
      sudo "apt-get install -y filebeat"
      sudo "mkdir -p /etc/pki/tls/certs"
      run "wget https://gist.githubusercontent.com/pyrat/0ef4a2e6e9d5b8556518385379648187/raw/29479a25ce70bd0ddb24ed02562f73ab7c209d71/logstash-forwarder.crt"
      sudo "mv logstash-forwarder.crt /etc/pki/tls/certs/"
    end

    desc "Configure filebeat on remote servers"
    task :configure do

      generated = render('filebeat', binding)
      puts generated
      put generate, "#{application}"
      sudo "mv #{application}, /etc/filebeat/filebeat.yml"
      
      sudo "service filebeat restart"
      sudo "update-rc.d filebeat defaults 95 10"
    end


  end



end
