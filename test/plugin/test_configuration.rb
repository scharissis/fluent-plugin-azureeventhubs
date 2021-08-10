require 'helper'
require 'pry'

require 'fluent/plugin/out_azureeventhubs_buffered'

class FileOutputTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  CONFIG = %(
    connection_string "connStr;a;b"
    hub_name    "hubName"
  )

  def setup
    Fluent::Test.setup   # Setup test for Fluentd (Required)
  end

  def teardown
    # Terminate test for plugin (Optional)
  end

  def create_driver(conf = CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::AzureEventHubsOutputBuffered).configure(conf)
  end

  # Configuration related test group
  sub_test_case 'configuration' do
    test 'basic configuration' do
      d = create_driver
      d.run(default_tag: 'test') do
        d.feed({ 'log' => { 'action' => 'login', 'password' => 'hunter1', 'email' => 'hunt@er.com' } })
      end
      #binding.pry
      assert_equal(1, d.instance.emit_count)
    end
  end

end
