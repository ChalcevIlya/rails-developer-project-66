# frozen_string_literal: true

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

  def create_webhook(_full_name, _url); end
end
