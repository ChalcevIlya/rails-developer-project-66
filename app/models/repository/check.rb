# frozen_string_literal: true

class Repository::Check < ApplicationRecord
  include AASM

  belongs_to :repository

  validates :commit_id, presence: true, allow_nil: true

  aasm do
    state :created, initial: true
    state :fetching
    state :fetched
    state :checking
    state :checked
    state :failed

    event :start_fetch do
      transitions from: :created, to: :fetching
    end

    event :finish_fetch do
      transitions from: :fetching, to: :fetched
    end

    event :start_check do
      transitions from: :fetched, to: :checking
    end

    event :finish_check do
      transitions from: :checking, to: :checked
    end

    event :fail do
      transitions from: %i[created fetching fetched checking], to: :failed
    end
  end
end
