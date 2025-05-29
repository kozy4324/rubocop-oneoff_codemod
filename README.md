# RuboCop::OneoffCodemod

A RuboCop plugin implementing comment-as-command for one-off codemod, inspired by [eslint-plugin-command](https://eslint-plugin-command.antfu.me/).

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add rubocop-oneoff_codemod
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install rubocop-oneoff_codemod
```

## Loading the plugin

To use this plugin, tell RuboCop to load it by adding the following to your `.rubocop.yml`:

```yml
plugins: rubocop-oneoff_codemod
```

If you're using multiple plugins, use the array notation:

```yml
plugins:
  - rubocop-other-plugin
  - rubocop-oneoff_codemod
```

RuboCop will now automatically load this plugin when you run it.

> [!NOTE]
> The plugin system is supported in RuboCop 1.72+.

## Usage

The `OneoffCodemod` cop is a special kind of RuboCop plugin. By default, does nothing.
Rather than checking code quality, it acts as a micro-codemod tool that is triggered by special comments.
It reuses RuboCop’s infrastructure to perform transformations on demand.

For example, the comment `# @keep-unique` transforms an array by removing duplicate elements:

```rb
# @keep-unique
ary = [1, 2, 3, 2, 4]
```

After running `rubocop -a` or saving the file in your editor, the array will be transformed and the comment will be removed:

```rb
#
ary = [1, 2, 3, 4]
```

## Available Commands

- `# @keep-unique` - Keep array items unique, removing duplicates.
- `# @rbs-prototype` - Run rbs prototype and generates boilerplate signature declaration.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kozy4324/rubocop-oneoff_codemod. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/rubocop-oneoff_codemod/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RuboCop::OneoffCodemod project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kozy4324/rubocop-oneoff_codemod/blob/master/CODE_OF_CONDUCT.md).
