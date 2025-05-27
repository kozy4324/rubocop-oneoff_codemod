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
          if node.loc&.line == target_line && node.is_a?(RuboCop::AST::DefNode)
            node
          else
            node.child_nodes.find do |child_node|
              find_node_on_line child_node, target_line
            end
          end
        end

        def on_new_investigation
          processed_source.comments.each do |comment|
            next unless comment.text == "# @#{COMMAND}"

            target_node = find_node_on_line(processed_source.ast, comment.location.line + 1)
            target_method = target_node.method_name

            add_offense(comment.location.expression) do |corrector|
              parser = RBS::Prototype::RB.new
              parser.parse processed_source.raw_source
              string = []
              parser.decls.each do |decl|
                decl.members.each do |member|
                  string << member.overloads.map(&:method_type).join(" | ") if target_method == member.name
                end
              end

              corrector.replace(comment.location.expression, "# #{string.join}")
            end
          end
        end
      end
    end
  end
end
