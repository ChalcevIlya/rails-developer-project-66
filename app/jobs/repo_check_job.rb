# frozen_string_literal: true

class RepoCheckJob < ApplicationJob
  queue_as :default

  def perform(check)
    CheckRepoService.new(check).call
  end
end
