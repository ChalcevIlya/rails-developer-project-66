class RenameCheckedToFinishedInRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    Repository::Check.where(aasm_state: 'checked').update_all(aasm_state: 'finished')
  end
end
