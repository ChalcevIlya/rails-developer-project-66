# frozen_string_literal: true

require 'ostruct'

class GithubClientStub
  def initialize(_token = nil); end

  def repos
    [
      OpenStruct.new(
        id: 453_780,
        name: 'test-repo',
        full_name: 'user/test-repo',
        language: 'Ruby',
        clone_url: 'https://github.com/user/test-repo.git',
        ssh_url: 'git@github.com:user/test-repo.git'
      ),
      OpenStruct.new(
        id: 789_012,
        name: 'test-js-repo',
        full_name: 'user/test-js-repo',
        language: 'JavaScript',
        clone_url: 'https://github.com/user/test-js-repo.git',
        ssh_url: 'git@github.com:user/test-js-repo.git'
      )
    ]
  end

  def last_commit(_full_name, _branch = 'main')
    'testsha123456shatest'
  end

  def find_repo(github_id)
    repos.find { |repo| repo.id == github_id } ||
      OpenStruct.new(
        id: github_id,
        name: "repo-#{github_id}",
        full_name: "user/repo-#{github_id}",
        language: 'Ruby',
        clone_url: "https://github.com/user/repo-#{github_id}.git",
        ssh_url: "git@github.com:user/repo-#{github_id}.git"
      )
  end

  def hooks(_full_name)
    []
  end

  def create_webhook(_full_name, _url); end
end
