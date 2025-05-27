# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Codemod::KeepUnique, :config do # rubocop:disable Metrics/BlockLength
  it "registers an offense when put `@keep-unique` comment with ArrayNode" do
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary = [1, 2, 3, 2, 4]
            ^^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
    RUBY

    expect_correction(<<~RUBY)
      #
      ary = [1, 2, 3, 4]
    RUBY
  end

  it "keeps quotes if Array items are strings" do
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary = ["a", "b", "a", "c"]
            ^^^^^^^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
    RUBY

    expect_correction(<<~RUBY)
      #
      ary = ["a", "b", "c"]
    RUBY
  end

  it "keeps the string-array literal notation (%w) when correcting" do
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary1 = %w|a b a c|
             ^^^^^^^^^^^ Keep array items unique, removing duplicates.

      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary2 = %w<a b a c>
             ^^^^^^^^^^^ Keep array items unique, removing duplicates.
    RUBY

    expect_correction(<<~RUBY)
      #
      ary1 = %w|a b c|

      #
      ary2 = %w<a b c>
    RUBY
  end

  it "keeps linebreaks" do # rubocop:disable Metrics/BlockLength
    expect_offense(<<~RUBY)
      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary1 = [1,
             ^^^ Keep array items unique, removing duplicates.
              2,
              3,
              2,
              4]

      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary2 = [1, 2,
             ^^^^^^ Keep array items unique, removing duplicates.
              2, 3, 4]

      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary3 = %w<1 2 3
             ^^^^^^^^ Keep array items unique, removing duplicates.
                3 4 5
                6 7 8>

      # @keep-unique
      ^^^^^^^^^^^^^^ Keep array items unique, removing duplicates.
      ary4 = %w|1 2
             ^^^^^^ Keep array items unique, removing duplicates.
                3 4
                3 2
                5 6
                1|
    RUBY

    expect_correction(<<~RUBY)
      #
      ary1 = [1,
              2,
              3,
              4]

      #
      ary2 = [1, 2,
              3, 4]

      #
      ary3 = %w<1 2 3
                4 5
                6 7 8>

      #
      ary4 = %w|1 2
                3 4
                5 6|
    RUBY
  end
end
