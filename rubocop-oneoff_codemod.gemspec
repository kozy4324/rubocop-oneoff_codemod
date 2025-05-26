# frozen_string_literal: true

require_relative "lib/rubocop/oneoff_codemod/version"

Gem::Specification.new do |spec| # rubocop:disable Gemspec/RequireMFA
  spec.name = "rubocop-oneoff_codemod"
  spec.version = RuboCop::OneoffCodemod::VERSION
  spec.authors = ["Koji NAKAMURA"]
  spec.email = ["kozy4324@gmail.com"]

  spec.summary = "A RuboCop plugin implementing comment-as-command for one-off codemod, inspired by eslint-plugin-command." # rubocop:disable Layout/LineLength
  spec.description = "A RuboCop plugin implementing comment-as-command for one-off codemod, inspired by eslint-plugin-command." # rubocop:disable Layout/LineLength
  spec.homepage = "https://github.com/kozy4324/rubocop-oneoff_codemod"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "lint_roller", "~> 1.1"
  spec.add_dependency "rubocop", ">= 1.72.1", "< 2.0"

  spec.metadata["default_lint_roller_plugin"] = "RuboCop::OneoffCodemod::Plugin"
end
