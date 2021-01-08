Clamby.configure({
                   :daemonize => true,
                   :stream => true,
                   :error_clamscan_missing => true,
                   :error_file_missing => true,
                   :error_file_virus => true,
                   :output_level => 'high',
                   :config_file => '/app/config/antivirus/clamd.conf'
                 })
