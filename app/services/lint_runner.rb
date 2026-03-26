# frozen_string_literal: true

class LintRunner
  def self.run(repo_path, config_path = nil)
    config_option = config_path ? "--config #{config_path}" : ''
    command = "rubocop #{repo_path} #{config_option} --format json"

    stdout, _stderr, status = Open3.capture3(command)
    [stdout, status.exitstatus]
  end
end
