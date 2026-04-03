# frozen_string_literal: true

class Api::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    repository = Repository.find_by(github_id: payload[:repository][:id])
    return head :not_found if repository.nil?

    check = repository.checks.create!(commit_id: payload[:after])
    RepoCheckJob.perform_later(check)

    head :ok
  end

  private

  def payload
    @payload ||= JSON.parse(request.body.read, symbolize_names: true)
  end
end
