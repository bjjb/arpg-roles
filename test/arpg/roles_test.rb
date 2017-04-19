require 'test_helper'
require 'active_record'
require 'arpg/roles'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])

ActiveRecord::Base.connection.create_table(:users, force: true) do |t|
  t.string :name
  t.string :roles, array: true, index: { using: :gin }
end

class User < ActiveRecord::Base
  include ARPG::Roles
  roles :butcher, :baker, :candlestickmaker
end

User.create(name: 'Alice', roles: %w(butcher baker))
User.create(name: 'Bob', roles: %w(baker candlestickmaker))
User.create(name: 'Cecil', roles: %w(candlestickmaker))

class ARPG::RolesTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::ARPG::Roles::VERSION
  end

  def test_role_class_methods_return_relations
    assert User.butcher.pluck(:name) == %w(Alice)
    assert User.baker.pluck(:name) == %w(Alice Bob)
    assert User.candlestickmaker.pluck(:name) == %w(Bob Cecil)
    assert_raises(NoMethodError) { User.president }
  end

  def test_role_instance_predicate_methods_return_booleans
    assert User.find_by(name: 'Alice').butcher?, "Alice should be a butcher"
    assert User.find_by(name: 'Alice').baker?, "Alice should be a baker"
    refute User.find_by(name: 'Alice').candlestickmaker?, "Alice shouldn't be a candlestickmaker"
    refute User.find_by(name: 'Bob').butcher?, "Bob shoudn't be a butcher"
    assert User.find_by(name: 'Bob').baker?, "Bob should be a baker"
    assert User.find_by(name: 'Bob').candlestickmaker?, "Bob should be a candlestickmaker"
    refute User.find_by(name: 'Cecil').butcher?, "Cecil shouldn't be a butcher"
    refute User.find_by(name: 'Cecil').baker?, "Cecil shouldn't be a baker"
    assert User.find_by(name: 'Cecil').candlestickmaker?, "Cecil should be a candlestickmaker"
  end
end
