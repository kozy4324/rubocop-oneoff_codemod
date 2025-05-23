# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Codemod::Command, :config do
  it "registers an offense when put `@keep-unique` comment with ArrayNode" do
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ keep-unique
      ary = [1, 2, 3, 2, 4]
            ^^^^^^^^^^^^^^^ keep-unique
    RUBY

    expect_correction(<<~RUBY)
      #
      ary = [1, 2, 3, 4]
    RUBY
  end
end
