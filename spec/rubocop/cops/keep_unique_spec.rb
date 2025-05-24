# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Codemod::KeepUnique, :config do # rubocop:disable Metrics/BlockLength
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

  it "keeps quotes if Array items are strings" do
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ keep-unique
      ary = ["a", "b", "a", "c"]
            ^^^^^^^^^^^^^^^^^^^^ keep-unique
    RUBY

    expect_correction(<<~RUBY)
      #
      ary = ["a", "b", "c"]
    RUBY
  end

  it "keeps the string-array literal notation (%w) when correcting" do
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ keep-unique
      ary1 = %w|a b a c|
             ^^^^^^^^^^^ keep-unique

      # @keep-unique
      ^^^^^^^^^^^^^^ keep-unique
      ary2 = %w<a b a c>
             ^^^^^^^^^^^ keep-unique
    RUBY

    expect_correction(<<~RUBY)
      #
      ary1 = %w|a b c|

      #
      ary2 = %w<a b c>
    RUBY
  end
end
