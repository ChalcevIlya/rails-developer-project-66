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
      )
    ]
  end

  def last_commit(_full_name, _branch = 'main')
    'testsha123456shatest'
  end
end
