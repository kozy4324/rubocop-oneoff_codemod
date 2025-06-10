# frozen_string_literal: true

require "rbs"

module RuboCop
  module Cop
    module Codemod
      # KeepUnique
      class RbsPrototype < Base
        extend AutoCorrector
        include IgnoredNode

        MSG = "Run rbs prototype and generates boilerplate signature declaration."
        COMMAND = "rbs-prototype"

        def initialize(*args)
          super
          @commands = {}
        end

        def find_node_on_line(node, target_line)
          return if node.nil?

          if node.is_a?(RuboCop::AST::DefNode) && node.loc&.line == target_line # steep:ignore
            node
          else
            found = nil
            node.child_nodes.each do |child_node| # steep:ignore
              found = find_node_on_line child_node, target_line
              break if found
            end
            found
          end
        end

        def on_new_investigation
          processed_source.comments.each do |comment|
            next unless comment.text == "# @#{COMMAND}" # steep:ignore

            target_node = find_node_on_line(processed_source.ast, comment.location.line + 1) # steep:ignore
            next if target_node.nil?

            target_method = target_node.method_name # steep:ignore

            add_offense(comment.location.expression) do |corrector| # steep:ignore
              parser = RBS::Prototype::RB.new
              parser.parse processed_source.raw_source
              string = Array.new(0, "")
              parser.decls.each do |decl|
                decl.members.each do |member| # steep:ignore
                  string << member.overloads.map(&:method_type).join(" | ") if target_method == member.name
                end
              end

              corrector.replace(comment.location.expression, "#: #{string.join}") # steep:ignore
            end
          end
        end
      end
    end
  end
end
