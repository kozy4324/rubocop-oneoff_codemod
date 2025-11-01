# frozen_string_literal: true

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
          return unless node.loc.expression.source.start_with?("[") || node.loc.expression.source.start_with?("%w")

          add_offense(node) do |corrector| # rubocop:disable Metrics/BlockLength
            next if part_of_ignored_node?(node)

            indent = " " * node.children.first.loc.column
            if node.loc.expression.source.start_with? "["
              separator = ", "
              line_separator = ",\n#{indent}"
            else
              separator = " "
              line_separator = "\n#{indent}"
            end

            node_loc = node.loc #: Parser::Source::Map::Collection
            next if node_loc.begin.nil? || node_loc.end.nil?

            # @type var content: Array[String]
            content = []
            content << node_loc.begin.source
            begin_to_first_value = processed_source.raw_source[node_loc.begin.end_pos..(node.values.first.loc.expression.begin_pos - 1)] # rubocop:disable Layout/LineLength
            content << begin_to_first_value unless begin_to_first_value.nil?

            acc = node.values.uniq(&:source).each_with_object([]) do |v_node, acc|
              if acc.last&.last&.loc&.line != v_node.loc.line # rubocop:disable Style/SafeNavigationChainLength,Style/NegatedIfElseCondition
                acc << [v_node]
              else
                acc.last << v_node
              end
            end
            content << acc.map { |a| a.map(&:source).join(separator) }.join(line_separator)

            last_value_to_end = processed_source.raw_source[node.values.last.loc.expression.end_pos..(node_loc.end.begin_pos - 1)] # rubocop:disable Layout/LineLength
            content << last_value_to_end unless last_value_to_end.nil?
            content << node_loc.end.source

            corrector.replace(node, content.join)
          end

          ignore_node(node)
        end
      end
    end
  end
end
