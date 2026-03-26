# frozen_string_literal: true

class GithubClient
  def initialize(token)
    @client = Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  delegate :repos, to: :@client

  def last_commit(full_name, branch = 'main')
    @client.commits(full_name, branch).first.sha
  end
end
