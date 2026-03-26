# frozen_string_literal: true

class LintRunner
  def self.run(repo_path, language)
    case language.downcase
    when 'ruby'
      run_rubocop(repo_path)
    when 'javascript'
      run_eslint(repo_path)
    else
      ['Unsupported language', 1]
    end
  end

  def self.run_rubocop(repo_path)
    config_path = Rails.root.join('.rubocop.yml').to_s
    command = "rubocop #{repo_path} --config #{config_path} --format json"

    stdout, _stderr, status = Open3.capture3(command)
    [stdout, status.exitstatus]
  end

  def self.run_eslint(repo_path)
    config_path = Rails.root.join('.eslintrc.json').to_s
    eslint_path = Rails.root.join('node_modules/.bin/eslint').to_s
    command = "#{eslint_path} #{repo_path} --no-eslintrc --config #{config_path} --format json"

    stdout, _stderr, status = Open3.capture3(command)
    [stdout, status.exitstatus]
  end
end
