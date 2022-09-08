module Scenarios
  module Foreman
    class Abstract < ForemanMaintain::Scenario
      def self.target_version
        raise NotImplementedError
      end

      def self.upgrade_metadata(&block)
        target_version = self.target_version

        metadata do
          tags :upgrade_scenario
          confine do
            feature(:foreman_install) || ForemanMaintain.upgrade_in_progress == target_version
          end

          @target_version = target_version
          def target_version
            @target_version
          end

          instance_eval(&block)
        end
      end

      def target_version
        self.class.target_version
      end
    end
  end
end
