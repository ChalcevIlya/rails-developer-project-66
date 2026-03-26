# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :github_client, -> { GithubClientStub }
    register :lint_runner, -> { LintRunnerStub }
    register :repo_cloner, -> { RepoClonerStub }
  else
    register :github_client, -> { GithubClient }
    register :lint_runner, -> { LintRunner }
    register :repo_cloner, -> { RepoCloner }
  end
end
