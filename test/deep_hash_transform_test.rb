require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'
$VERBOSE = true

require 'deep_hash_transform'

class TransformTest < Minitest::Test
  def setup
    @strings = { 'a' => 1, 'b' => 2 }
    @nested_strings = { 'a' => { 'b' => { 'c' => 3 } } }
    @symbols = { :a  => 1, :b  => 2 }
    @nested_symbols = { :a => { :b => { :c => 3 } } }
    @mixed   = { :a  => 1, 'b' => 2 }
    @nested_mixed   = { 'a' => { :b => { 'c' => 3 } } }
    @fixnums = {  0  => 1,  1  => 2 }
    @nested_fixnums = {  0  => { 1  => { 2 => 3} } }
    @illegal_symbols = { [] => 3 }
    @nested_illegal_symbols = { [] => { [] => 3} }
    @upcase_strings = { 'A' => 1, 'B' => 2 }
    @nested_upcase_strings = { 'A' => { 'B' => { 'C' => 3 } } }
  end

  def test_transform_keys
    assert_equal @upcase_strings, @strings.transform_keys { |key| key.to_s.upcase }
    assert_equal @upcase_strings, @symbols.transform_keys { |key| key.to_s.upcase }
    assert_equal @upcase_strings, @mixed.transform_keys { |key| key.to_s.upcase }
  end

  def test_transform_keys_not_mutates
    transformed_hash = @mixed.dup
    transformed_hash.transform_keys { |key| key.to_s.upcase }
    assert_equal @mixed, transformed_hash
  end

  def test_deep_transform_keys
    assert_equal @nested_upcase_strings, @nested_symbols.deep_transform_keys { |key| key.to_s.upcase }
    assert_equal @nested_upcase_strings, @nested_strings.deep_transform_keys { |key| key.to_s.upcase }
    assert_equal @nested_upcase_strings, @nested_mixed.deep_transform_keys { |key| key.to_s.upcase }
  end

  def test_deep_transform_keys_not_mutates
    transformed_hash = deep_dup(@nested_mixed)
    transformed_hash.deep_transform_keys { |key| key.to_s.upcase }
    assert_equal @nested_mixed, transformed_hash
  end

  def test_transform_keys!
    assert_equal @upcase_strings, @symbols.dup.transform_keys! { |key| key.to_s.upcase }
    assert_equal @upcase_strings, @strings.dup.transform_keys! { |key| key.to_s.upcase }
    assert_equal @upcase_strings, @mixed.dup.transform_keys! { |key| key.to_s.upcase }
  end

  def test_transform_keys_with_bang_mutates
    transformed_hash = @mixed.dup
    transformed_hash.transform_keys! { |key| key.to_s.upcase }
    assert_equal @upcase_strings, transformed_hash
    assert_equal @mixed, { :a => 1, "b" => 2 }
  end

  def test_deep_transform_keys!
    assert_equal @nested_upcase_strings, deep_dup(@nested_symbols).deep_transform_keys! { |key| key.to_s.upcase }
    assert_equal @nested_upcase_strings, deep_dup(@nested_strings).deep_transform_keys! { |key| key.to_s.upcase }
    assert_equal @nested_upcase_strings, deep_dup(@nested_mixed).deep_transform_keys! { |key| key.to_s.upcase }
  end

  def test_deep_transform_keys_with_bang_mutates
    transformed_hash = deep_dup(@nested_mixed)
    transformed_hash.deep_transform_keys! { |key| key.to_s.upcase }
    assert_equal @nested_upcase_strings, transformed_hash
    assert_equal @nested_mixed, { 'a' => { :b => { 'c' => 3 } } }
  end

  def test_symbolize_keys
    assert_equal @symbols, @symbols.symbolize_keys
    assert_equal @symbols, @strings.symbolize_keys
    assert_equal @symbols, @mixed.symbolize_keys
  end

  def test_symbolize_keys_not_mutates
    transformed_hash = @mixed.dup
    transformed_hash.symbolize_keys
    assert_equal @mixed, transformed_hash
  end

  def test_deep_symbolize_keys
    assert_equal @nested_symbols, @nested_symbols.deep_symbolize_keys
    assert_equal @nested_symbols, @nested_strings.deep_symbolize_keys
    assert_equal @nested_symbols, @nested_mixed.deep_symbolize_keys
  end

  def test_deep_symbolize_keys_not_mutates
    transformed_hash = deep_dup(@nested_mixed)
    transformed_hash.deep_symbolize_keys
    assert_equal @nested_mixed, transformed_hash
  end

  def test_symbolize_keys!
    assert_equal @symbols, @symbols.dup.symbolize_keys!
    assert_equal @symbols, @strings.dup.symbolize_keys!
    assert_equal @symbols, @mixed.dup.symbolize_keys!
  end

  def test_symbolize_keys_with_bang_mutates
    transformed_hash = @mixed.dup
    transformed_hash.deep_symbolize_keys!
    assert_equal @symbols, transformed_hash
    assert_equal @mixed, { :a => 1, "b" => 2 }
  end

  def test_deep_symbolize_keys!
    assert_equal @nested_symbols, deep_dup(@nested_symbols).deep_symbolize_keys!
    assert_equal @nested_symbols, deep_dup(@nested_strings).deep_symbolize_keys!
    assert_equal @nested_symbols, deep_dup(@nested_mixed).deep_symbolize_keys!
  end

  def test_deep_symbolize_keys_with_bang_mutates
    transformed_hash = deep_dup(@nested_mixed)
    transformed_hash.deep_symbolize_keys!
    assert_equal @nested_symbols, transformed_hash
    assert_equal @nested_mixed, { 'a' => { :b => { 'c' => 3 } } }
  end

  def test_symbolize_keys_preserves_keys_that_cant_be_symbolized
    assert_equal @illegal_symbols, @illegal_symbols.symbolize_keys
    assert_equal @illegal_symbols, @illegal_symbols.dup.symbolize_keys!
  end

  def test_deep_symbolize_keys_preserves_keys_that_cant_be_symbolized
    assert_equal @nested_illegal_symbols, @nested_illegal_symbols.deep_symbolize_keys
    assert_equal @nested_illegal_symbols, deep_dup(@nested_illegal_symbols).deep_symbolize_keys!
  end

  def test_symbolize_keys_preserves_fixnum_keys
    assert_equal @fixnums, @fixnums.symbolize_keys
    assert_equal @fixnums, @fixnums.dup.symbolize_keys!
  end

  def test_deep_symbolize_keys_preserves_fixnum_keys
    assert_equal @nested_fixnums, @nested_fixnums.deep_symbolize_keys
    assert_equal @nested_fixnums, deep_dup(@nested_fixnums).deep_symbolize_keys!
  end

  def test_stringify_keys
    assert_equal @strings, @symbols.stringify_keys
    assert_equal @strings, @strings.stringify_keys
    assert_equal @strings, @mixed.stringify_keys
  end

  def test_stringify_keys_not_mutates
    transformed_hash = @mixed.dup
    transformed_hash.stringify_keys
    assert_equal @mixed, transformed_hash
  end

  def test_deep_stringify_keys
    assert_equal @nested_strings, @nested_symbols.deep_stringify_keys
    assert_equal @nested_strings, @nested_strings.deep_stringify_keys
    assert_equal @nested_strings, @nested_mixed.deep_stringify_keys
  end

  def test_deep_stringify_keys_not_mutates
    transformed_hash = deep_dup(@nested_mixed)
    transformed_hash.deep_stringify_keys
    assert_equal @nested_mixed, transformed_hash
  end

  def test_stringify_keys!
    assert_equal @strings, @symbols.dup.stringify_keys!
    assert_equal @strings, @strings.dup.stringify_keys!
    assert_equal @strings, @mixed.dup.stringify_keys!
  end

  def test_stringify_keys_with_bang_mutates
    transformed_hash = @mixed.dup
    transformed_hash.stringify_keys!
    assert_equal @strings, transformed_hash
    assert_equal @mixed, { :a => 1, "b" => 2 }
  end

  def test_deep_stringify_keys!
    assert_equal @nested_strings, deep_dup(@nested_symbols).deep_stringify_keys!
    assert_equal @nested_strings, deep_dup(@nested_strings).deep_stringify_keys!
    assert_equal @nested_strings, deep_dup(@nested_mixed).deep_stringify_keys!
  end

  def test_deep_stringify_keys_with_bang_mutates
    transformed_hash = deep_dup(@nested_mixed)
    transformed_hash.deep_stringify_keys!
    assert_equal @nested_strings, transformed_hash
    assert_equal @nested_mixed, { 'a' => { :b => { 'c' => 3 } } }
  end

  private
    def deep_dup(hash)
      Marshal.load(Marshal.dump(hash))
    end
end

# Put a fake Active Support implementation in the load path to verify that
# we defer to its Hash extensions when they're already defined.
class ForwardCompatibilityTest < Minitest::Test
  def setup;    expunge_loaded_features end
  def teardown; expunge_loaded_features end

  def test_check_for_active_support_implementation_before_providing_our_own
    assert_equal [], $LOADED_FEATURES.grep(/hash\/keys/)

    with_stubbed_active_support_in_load_path do
      require 'deep_hash_transform'
    end

    assert defined?(::STUBBED_ACTIVE_SUPPORT_HASH_KEYS_EXTENSIONS)

    Hash::STUBS.each do |stub|
      assert_equal :trololo, Hash.new.send(stub)
    end
  end

  private
  def expunge_loaded_features
    $LOADED_FEATURES.delete_if { |feature| feature =~ /deep_hash_transform/ }
  end

  def with_stubbed_active_support_in_load_path
    $LOAD_PATH.unshift File.expand_path('../active_support_stub', __FILE__)
    old_verbose, $VERBOSE = $VERBOSE, nil
    yield
  ensure
    $VERBOSE = old_verbose
    $LOAD_PATH.shift
  end
end
