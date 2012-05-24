Capistrano::Configuration.instance(true).load do
  
  namespace :ssl do

    desc "Uploads certificates to the server, default to /etc/certs, supports ssl_cert_path, ssl_key_path, ssl_chain_path"
    task :upload_certs do

      _cset :base_cert_path, "/etc/certs"
      _cset :ssl_certs_path, ""
      _cset :ssl_key_path, ""

      begin
        sudo "mkdir #{base_cert_path}"
      rescue
        # ignore
      end

      upload(ssl_certs_path, "cap_certs", :via => :scp, :recursive => true)
      sudo "cp -R cap_certs/* #{base_cert_path}"
      # Clean up the cap_certs temp dir
      sudo "rm -fr cap_certs"
    end

  end
  
end