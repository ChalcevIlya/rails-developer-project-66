# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  enumerize :language, in: %i[Ruby], predicates: true

  belongs_to :user

  validates :name, presence: true
  validates :github_id, presence: true, uniqueness: true
  validates :full_name, presence: true
  validates :clone_url, presence: true
  validates :ssh_url, presence: true
  validates :language, presence: true
end
