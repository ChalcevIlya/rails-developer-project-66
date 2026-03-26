# frozen_string_literal: true

require 'open3'

class CheckRepoService
  def initialize(check)
    @check = check
    @repository = check.repository
  end

  def call
    clone_repo!
    lint!
  rescue StandardError => e
    Rails.logger.error("Check failed: #{e.message}")
    Rails.logger.error(e.backtrace.first(5).join("\n"))
    @check.fail!
  ensure
    cleanup
  end

  private

  def clone_repo!
    @check.start_fetch!

    repo_path = Rails.root.join('tmp', 'repos_for_check', @check.id.to_s)
    @cloned_repo_path = repo_path.to_s

    repo_cloner = ApplicationContainer[:repo_cloner]
    repo_cloner.clone(@repository.clone_url, @cloned_repo_path)

    @check.finish_fetch!
  end

  def lint!
    @check.start_check!

    lint_runner = ApplicationContainer[:lint_runner]
    output, _exit_status = lint_runner.run(@cloned_repo_path, @repository.language)

    @check.update!(result: output)
    @check.finish_check!
  end

  def cleanup
    FileUtils.rm_rf(@cloned_repo_path) if @cloned_repo_path
  end
end
