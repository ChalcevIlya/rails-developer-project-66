class MakeRepositoryUrlsNullable < ActiveRecord::Migration[7.2]
  def change
    change_column_null :repositories, :clone_url, true
    change_column_null :repositories, :ssh_url, true
  end
end
