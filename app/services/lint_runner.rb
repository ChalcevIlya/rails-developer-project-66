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
    rubocop_path = Gem.bin_path('rubocop', 'rubocop')
    dirs = %w[app lib].map { |d| "#{repo_path}/#{d}" }.select { |d| Dir.exist?(d) }.join(' ')
    command = "#{rubocop_path} #{dirs} --config #{config_path} --format json"

    stdout, _stderr, status = Open3.capture3(command)
    [parse_rubocop_output(stdout), status.exitstatus]
  end

  def self.parse_rubocop_output(stdout)
    raw = JSON.parse(stdout)
    {
      offenses_count: raw.dig('summary', 'offense_count'),
      files: raw['files'].select { |f| f['offenses'].any? }.map do |f|
        {
          path: f['path'],
          offenses: f['offenses'].map do |o|
            { line: o.dig('location', 'line'), cop_name: o['cop_name'], message: o['message'] }
          end
        }
      end
    }.to_json
  end

  def self.run_eslint(repo_path)
    config_path = Rails.root.join('.eslintrc.json').to_s
    eslint_path = Rails.root.join('node_modules/.bin/eslint').to_s
    command = "#{eslint_path} #{repo_path} --no-eslintrc --config #{config_path} --format json"

    stdout, _stderr, status = Open3.capture3(command)
    [stdout, status.exitstatus]
  end
end
