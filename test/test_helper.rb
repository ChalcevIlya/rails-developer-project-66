# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require_relative 'helpers/sign_in_helper'
require 'rails/test_help'
require 'minitest/power_assert'
require 'minitest/mock'
require 'ostruct'

OmniAuth.config.test_mode = true
ActiveSupport.on_load(:action_dispatch_integration_test) { include SignInHelper }

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
