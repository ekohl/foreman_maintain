require_relative '../foreman'

module Scenarios
  module Foreman
    module Nightly
      class Abstract < Scenarios::Foreman::Abstract
        def self.target_version
          self.name.split('::')[-2].downcase
        end
      end

      class PreUpgradeCheck < Abstract
        upgrade_metadata do
          description "Checks before upgrading to Foreman #{target_version}"
          tags :pre_upgrade_checks
          run_strategy :fail_slow
        end

        def compose
          add_steps(find_checks(:default))
          add_steps(find_checks(:pre_upgrade))
        end
      end

      class PreMigrations < Abstract
        upgrade_metadata do
          description "Procedures before upgrading to Foreman #{target_version}"
          tags :pre_migrations
        end

        def compose
          add_steps(find_procedures(:pre_migrations))
        end
      end

      class Migrations < Abstract
        upgrade_metadata do
          description "Upgrade steps for Foreman #{target_version}"
          tags :migrations
          run_strategy :fail_fast
        end

        def set_context_mapping
          context.map(:assumeyes, Procedures::Installer::Upgrade => :assumeyes)
        end

        def compose
          add_step(Procedures::Repositories::Setup.new(:version => target_version))
          if el?
            modules_to_enable = ["foreman:#{el_short_name}"]
            add_step(Procedures::Packages::EnableModules.new(:module_names => modules_to_enable,
                                                             :assumeyes => true))
          end
          add_step(Procedures::Packages::Update.new(:assumeyes => true))
          add_step_with_context(Procedures::Installer::Upgrade)
        end
      end

      class PostMigrations < Abstract
        upgrade_metadata do
          description 'Post upgrade procedures for Foreman nightly'
          tags :post_migrations
        end

        def compose
          add_step(Procedures::RefreshFeatures)
          add_step(Procedures::Service::Start.new)
          add_steps(find_procedures(:post_migrations))
        end
      end

      class PostUpgradeChecks < Abstract
        upgrade_metadata do
          description "Checks after upgrading to Foreman #{target_version}"
          tags :post_upgrade_checks
          run_strategy :fail_slow
        end

        def compose
          add_steps(find_checks(:default))
          add_steps(find_checks(:post_upgrade))
        end
      end
    end
  end
end
