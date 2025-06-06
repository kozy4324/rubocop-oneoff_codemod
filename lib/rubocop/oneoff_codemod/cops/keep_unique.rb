# frozen_string_literal: true

# steep:ignore:start
module RuboCop
  module Cop
    module Codemod
      # KeepUnique
      class KeepUnique < Base
        extend AutoCorrector
        include IgnoredNode

        MSG = "Keep array items unique, removing duplicates."
        COMMAND = "keep-unique"

        def initialize(*args)
          super
          @commands = {}
        end

        def on_new_investigation
          processed_source.comments.each do |comment|
            next unless comment.text == "# @#{COMMAND}"

            @commands[comment.location.line] = COMMAND

            add_offense(comment.location.expression) do |corrector|
              corrector.replace(comment.location.expression, "#")
            end
          end
        end

        def command_exists?(node)
          @commands[node.location.line - 1] == COMMAND
        end

        def on_array(node)
          return unless command_exists? node
          return unless node.loc.begin.source == "[" || node.loc.begin.source.start_with?("%w")

          add_offense(node) do |corrector|
            next if part_of_ignored_node?(node)

            indent = " " * node.values.first.loc.column
            if node.loc.begin.source == "["
              separator = ", "
              line_separator = ",\n#{indent}"
            else
              separator = " "
              line_separator = "\n#{indent}"
            end

            content = []
            content << node.loc.begin.source
            content << processed_source.raw_source[node.loc.begin.end_pos..(node.values.first.loc.expression.begin_pos - 1)] # rubocop:disable Layout/LineLength

            acc = node.values.uniq(&:source).each_with_object([]) do |v_node, acc|
              acc << [] if acc.last&.last&.loc&.line != v_node.loc.line # rubocop:disable Style/SafeNavigationChainLength
              acc.last << v_node
            end
            content << acc.map { |a| a.map(&:source).join(separator) }.join(line_separator)

            content << processed_source.raw_source[node.values.last.loc.expression.end_pos..(node.loc.end.begin_pos - 1)] # rubocop:disable Layout/LineLength
            content << node.loc.end.source

            corrector.replace(node, content)
          end

          ignore_node(node)
        end
      end
    end
  end
end
# steep:ignore:end
