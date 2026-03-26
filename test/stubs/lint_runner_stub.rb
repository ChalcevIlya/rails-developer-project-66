# frozen_string_literal: true

class LintRunnerStub
  def self.run(_repo_path, _config_path = nil)
    result = {
      offenses_count: 1,
      output: [
        { path: 'app/main.rb', line: 5, message: 'Layout/TrailingWhitespace: Trailing whitespace detected.' }
      ]
    }
    [result.to_json, 0]
  end
end
