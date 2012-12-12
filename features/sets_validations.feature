Feature: sets validations
  Background:
    Given I successfully run `bundle exec rails new testapp --skip-bundle --skip-sprockets --skip-javascript`
    And I cd to "testapp"
    And I add "factory_girl_rails" as a dependency
    And I add "valle" from this project as a dependency
    And I successfully run `bundle install`
    And I successfully run `bundle exec rails g model User name:string`
    And I successfully run `bundle exec rake db:migrate --trace`

  @disable-bundler
  Scenario: Using Valle automatically sets validations
    When I write to "test/unit/user_test.rb" with:
      """
      require 'test_helper'

      class UserTest < ActiveSupport::TestCase
        test "should not save user when name is too long" do
          user = FactoryGirl.create(:user)
          user.name = 'a' * 256

          assert !user.save
          assert_equal 1, user.errors.count
        end
      end
      """
    When I successfully run `bundle exec rake test --trace`
    Then the output should contain "1 tests, 2 assertions, 0 failures, 0 errors"
