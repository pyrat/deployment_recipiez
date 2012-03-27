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

      put File.read(ssl_cert_path), File.basename(ssl_cert_path
      put File.read(ssl_key_path), File.basename(ssl_key_path)
      
      if exists? :ssl_chain_path
        put File.read(ssl_chain_path), File.basename(ssl_chain_path)
        sudo "mv #{File.basename(ssl_chain_path)} #{base_cert_path}/#{File.basename(ssl_chain_path)}"
      end

      sudo "mv #{File.basename(ssl_cert_path)} #{base_cert_path}/#{File.basename(ssl_cert_path)}"
      sudo "mv #{File.basename(ssl_key_path)} #{base_cert_path}/#{File.basename(ssl_key_path)}"

    end

  end
  
  
  
  
end