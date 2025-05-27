# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Codemod::RbsPrototype, :config do
  it "registers an offense when put `@rbs-prototype` comment with SendNode" do
    expect_offense(<<~RUBY)
      class Foo
        # @rbs-prototype
        ^^^^^^^^^^^^^^^^ Run rbs prototype and generates boilerplate signature declaration.
        def hoge(a, b)
          a + b
        end
      end
    RUBY

    expect_correction(<<~RUBY)
      class Foo
        #: (untyped a, untyped b) -> untyped
        def hoge(a, b)
          a + b
        end
      end
    RUBY
  end
end
