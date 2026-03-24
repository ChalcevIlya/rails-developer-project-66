class CreateRepositories < ActiveRecord::Migration[7.2]
  def change
    create_table :repositories do |t|
      t.string :name, null: false
      t.bigint :github_id, null: false
      t.string :full_name, null: false
      t.string :language, null: false
      t.string :clone_url, null: false
      t.string :ssh_url, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :repositories, :github_id, unique: true
  end
end
