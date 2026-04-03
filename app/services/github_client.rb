# frozen_string_literal: true

class GithubClient
  def initialize(token)
    @client = Octokit::Client.new(access_token: token, auto_paginate: true)
  end

  delegate :repos, to: :@client

  def last_commit(full_name, branch = 'main')
    @client.commits(full_name, branch).first.sha
  end

  def create_webhook(full_name, url)
    return if @client.hooks(full_name).any? { |h| h.config.url == url }

    @client.create_hook(
      full_name,
      'web',
      { url: url, content_type: 'json' },
      { events: ['push'], active: true }
    )
  end
end
