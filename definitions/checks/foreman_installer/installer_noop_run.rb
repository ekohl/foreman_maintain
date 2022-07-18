module Checks
  module ForemanInstaller
    class InstallerNoopRun < ForemanMaintain::Check
      metadata do
        description 'Run the installer in noop mode for system checks'
        tags :pre_upgrade
      end

      def run
        check_error_codes = [20, 102, 103]
        cmd_status, output = feature(:installer).run_with_status(' --noop')
        msg = "\nThe system does not comply with checks in the installer!\n"\
              "Fix the requirements:\n#{output}"
        if check_error_codes.include?(cmd_status)
          fail! msg
        elsif cmd_status != 0
          fail! output
        end
      end
    end
  end
end
