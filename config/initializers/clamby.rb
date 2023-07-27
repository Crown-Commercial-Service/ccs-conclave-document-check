if Rails.env.test? || Rails.env.development?
  Clamby.configure({
                     daemonize: true,
                     stream: true,
                     error_clamscan_missing: true,
                     error_file_missing: true,
                     error_file_virus: true,
                     output_level: 'high',
                     config_file: 'needs/a/path' # When running tests via docker-compose.built.yml
                     # it needs a dummy config file path or else it fails due to no file path
                   })
elsif ENV['AWS_NATIVE'] == 'true'
  Clamby.configure({
                     daemonize: true,
                     stream: true,
                     error_clamscan_client_error: true,
                     error_clamscan_missing: true,
                     error_file_missing: true,
                     error_file_virus: true,
                     config_file: '/app/config/antivirus/clamd.conf'
                   })
else
  Clamby.configure({
                     daemonize: true,
                     stream: true,
                     error_clamscan_missing: true,
                     error_file_missing: true,
                     error_file_virus: true,
                     config_file: '.apt/etc/clamav/clamd.conf',
                     output_level: 'high'
                   })
end
