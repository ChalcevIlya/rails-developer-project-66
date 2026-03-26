# frozen_string_literal: true

class RepoClonerStub
  def self.clone(_clone_url, cloned_repo_path)
    FileUtils.mkdir_p(cloned_repo_path)
  end
end
