# frozen_string_literal: true

class RepositoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @repositories = current_user.repositories.order(created_at: :desc)
  end

  def new
    @repository = current_user.repositories.build
    @github_repos = fetch_github_repos
  end

  def create
    github_repo = find_github_repo(params[:repository][:github_id].to_i)

    if github_repo.nil?
      flash[:alert] = t('.repo_not_found')
      redirect_to new_repository_path
      return
    end

    @repository = current_user.repositories.build(
      github_id: github_repo.id,
      name: github_repo.name,
      full_name: github_repo.full_name,
      language: github_repo.language,
      clone_url: github_repo.clone_url,
      ssh_url: github_repo.ssh_url
    )

    if @repository.save
      flash[:notice] = t('.success')
      redirect_to repositories_path
    else
      @github_repos = fetch_github_repos
      render :new, status: :unprocessable_content
    end
  end

  private

  def fetch_github_repos
    client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
    client.repos.select { |repo| repo.language&.downcase == 'ruby' }
  rescue Octokit::Error => e
    Rails.logger.error("GitHub API error: #{e.message}")
    []
  end

  def find_github_repo(github_id)
    client = Octokit::Client.new(access_token: current_user.token, auto_paginate: true)
    client.repos.find { |repo| repo.id == github_id }
  rescue Octokit::Error => e
    Rails.logger.error("GitHub API error: #{e.message}")
    []
  end
end
