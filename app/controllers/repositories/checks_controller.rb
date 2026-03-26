# frozen_string_literal: true

class Repositories::ChecksController < ApplicationController
  before_action :authenticate_user!

  def show
    @repository = current_user.repositories.find(params[:repository_id])
    @check = @repository.checks.find(params[:id])
  end

  def create
    @repository = current_user.repositories.find(params[:repository_id])
    commit_id = github_client.last_commit(@repository.full_name)

    @check = @repository.checks.create!(commit_id: commit_id)
    RepoCheckJob.perform_later(@check)

    redirect_to repository_check_path(@repository, @check),
                notice: t('.check_started')
  end
end
