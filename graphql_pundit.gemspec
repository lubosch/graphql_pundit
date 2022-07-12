# frozen_string_literal: true

require_relative 'lib/graphql_pundit/version'

Gem::Specification.new do |spec|
  spec.name = 'graphql_pundit'
  spec.version = GraphqlPundit::VERSION
  spec.authors = ['Lubomir Vnenk']
  spec.email = ['lubomir.vnenk@zoho.com']

  spec.summary = 'Pundit authorization support for new graphql interpreter'
  spec.description = spec.summary
  spec.homepage = 'https://github.com/lubosch/graphql_pundit'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lubosch/graphql_pundit/blob/master/README.md'
  spec.metadata['changelog_uri'] = 'https://github.com/lubosch/graphql_pundit/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'graphql', '>= 1.8', '< 3'
  spec.add_dependency 'pundit', '~> 2.1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'codecov', '~> 0.1.10'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.6'
  spec.add_development_dependency 'rubocop', '>= 0.83.0'
  spec.add_development_dependency 'simplecov', '~> 0.18.5'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
