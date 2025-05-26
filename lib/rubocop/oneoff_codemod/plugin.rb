# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module OneoffCodemod
    # A plugin that integrates RuboCop Oneoff Codemod with RuboCop's plugin system.
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-oneoff_codemod",
          version: RuboCop::OneoffCodemod::VERSION,
          homepage: "https://github.com/kozy4324/rubocop-oneoff_codemod",
          description: "A RuboCop plugin implementing comment-as-command for one-off codemod, inspired " \
                       "by eslint-plugin-command."
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(_context)
        project_root = Pathname.new(__dir__).join("../../../") # steep:ignore

        LintRoller::Rules.new(type: :path, config_format: :rubocop, value: project_root.join("config", "default.yml"))
      end
    end
  end
end
