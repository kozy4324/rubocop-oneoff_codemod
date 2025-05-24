# frozen_string_literal: true

module RuboCop
  module Cop
    module Codemod
      # Command
      class Command < Base
        extend AutoCorrector
        include IgnoredNode

        MSG = "keep-unique"

        def initialize(*args)
          super
          @commands = {}
        end

        def on_new_investigation
          processed_source.comments.each do |comment|
            next unless comment.text == "# @keep-unique"

            @commands[comment.location.line] = :keep_unique

            add_offense(comment.location.expression) do |corrector|
              corrector.replace(comment.location.expression, "#")
            end
          end
        end

        def on_array(node) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          return unless @commands[node.location.line - 1] == :keep_unique

          add_offense(node) do |corrector|
            next if part_of_ignored_node?(node)

            elements = node.values
            values = elements.map(&:source)
            uniq_values = values.uniq
            if node.loc.begin.source == "["
              corrector.replace(node, "[#{uniq_values.join(", ")}]")
            elsif node.loc.begin.source.start_with? "%w"
              corrector.replace(node, node.loc.begin.source + uniq_values.join(" ") + node.loc.end.source)
            end
          end

          ignore_node(node)
        end
      end
    end
  end
end
