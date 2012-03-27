Capistrano::Configuration.instance(true).load do
  
  namespace :ssl do

    desc "Uploads certificates to the server, default to /etc/certs, supports ssl_cert_path, ssl_key_path, ssl_chain_path"
    task :upload_certificate_pairs do

      _cset :base_cert_path, "/etc/certs"
      _cset :ssl_cert_path, ""
      _cset :ssl_key_path, ""
      
      begin
        sudo "mkdir #{base_cert_path}"
      rescue
        # ignore
      end
      
      upload(ssl_certs_path, base_cert_path, :via => :scp, :recursive => true)
    end

  end
  
  
  
  
end