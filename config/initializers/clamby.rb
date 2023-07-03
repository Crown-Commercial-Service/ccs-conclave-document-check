if Rails.env.test? || Rails.env.development?
  Clamby.configure({
                     daemonize: true,
                     stream: true,
                     error_clamscan_missing: true,
                     error_file_missing: true,
                     error_file_virus: true,
                     output_level: 'high'
                   })
else
  Clamby.configure({
                     daemonize: true,
                     stream: true,
                     error_clamscan_client_error: true,
                     error_clamscan_missing: true,
                     error_file_missing: true,
                     error_file_virus: true,
                     config_file: '/app/config/antivirus/clamd.conf',
                     output_level: 'high'
                   })
end
