# frozen_string_literal: true

class RepoCloner
  def self.clone(clone_url, cloned_repo_path)
    _stdout, stderr, status = Open3.capture3(
      'git', 'clone', '--depth', '1',
      '--branch', 'main',
      clone_url, cloned_repo_path
    )
    raise "Git clone failed: #{stderr}" unless status.success?
  end
end
