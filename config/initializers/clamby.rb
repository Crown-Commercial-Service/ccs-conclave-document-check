if Rails.env.test? || Rails.env.development?
  Clamby.configure({
                     :daemonize => true,
                     :stream => true,
                     :error_clamscan_missing => true,
                     :error_file_missing => true,
                     :error_file_virus => true,
                     :output_level => 'high'
                   })

else
  Clamby.configure({
                     :daemonize => true,
                     :stream => true,
                     :error_clamscan_missing => true,
                     :error_file_missing => true,
                     :error_file_virus => true,
                     :config_file => '.apt/etc/clamav/clamd.conf'
                   })

end