# frozen_string_literal: true

class LintRunnerStub
  def self.run(_repo_path, _language = nil)
    result = {
      offenses_count: 0,
      files: []
    }
    [result.to_json, 0]
  end
end
