# frozen_string_literal: true

module RuboCop
  module Cop
    module Codemod
      # KeepUnique
      class KeepUnique < Base
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

        def on_array(node) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength,Metrics/PerceivedComplexity
          return unless @commands[node.location.line - 1] == :keep_unique
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

            current_line = node.values.first.loc.line
            acc = node.values.uniq(&:source).inject([[]]) do |acc, v_node| # rubocop:disable Style/EachWithObject
              if current_line != v_node.loc.line
                current_line = v_node.loc.line
                acc << []
              end
              acc.last << v_node.source
              acc
            end
            content << acc.map { |a| a.join(separator) }.join(line_separator)

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
