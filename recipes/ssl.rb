Capistrano::Configuration.instance(true).load do
  
  namespace :ssl do

    desc "Uploads certificates to the server, default to /etc/certs"
    task :upload_certificate_pairs do

      _cset :base_cert_path, "/etc/certs"
      _cset :ssl_cert_path, ""
      _cset :ssl_key_path, ""


      put File.read(ssl_cert_path), File.basename(ssl_cert_path)
      put File.read(ssl_key_path), File.basename(ssl_key_path)

      begin
        sudo "mkdir #{base_cert_path}"
      rescue
        # ignore
      end

      sudo "mv #{File.basename(ssl_cert_path)} #{base_cert_path}/#{File.basename(ssl_cert_path)}"
      sudo "mv #{File.basename(ssl_key_path)} #{base_cert_path}/#{File.basename(ssl_key_path)}"


    end

  end
  
  
  
  
end