# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require_relative 'helpers/sign_in_helper'

require 'rails/test_help'
require 'faker'
require 'minitest/power_assert'
require 'minitest/mock'
require 'ostruct'
require 'webmock/minitest'
WebMock.disable_net_connect!(allow_localhost: true)

OmniAuth.config.test_mode = true
ActiveSupport.on_load(:action_dispatch_integration_test) { include SignInHelper }

module ActiveSupport
  class TestCase
    parallelize(workers: :number_of_processors)
    fixtures :all
  end
end
