# These features are available in Rails 4.0+
#
# Prefer Active Support's implementation when available.
#
# This allows libraries which support multiple Rails versions to depend on
# `deep_hash_transform` without worrying about implementation collision.
# This lib will step aside if it sees its work is done.
begin
  require 'active_support/core_ext/hash/keys'
rescue LoadError
  # No worries if Active Support isn't present. Can be used in isolation.
end

class Hash
  # Returns a new hash with all keys converted using the block operation.
  #
  #  hash = { name: 'Rob', age: '28' }
  #
  #  hash.transform_keys{ |key| key.to_s.upcase }
  #  # => {"NAME"=>"Rob", "AGE"=>"28"}
  def transform_keys
    result = {}
    each_key do |key|
      result[yield(key)] = self[key]
    end
    result
  end unless method_defined?(:transform_keys)

  # Destructively convert all keys using the block operations.
  # Same as transform_keys but modifies +self+.
  def transform_keys!
    keys.each do |key|
      self[yield(key)] = delete(key)
    end
    self
  end unless method_defined?(:transform_keys!)

  # Returns a new hash with all keys converted to strings.
  #
  #   hash = { name: 'Rob', age: '28' }
  #
  #   hash.stringify_keys
  #   # => { "name" => "Rob", "age" => "28" }
  def stringify_keys
    transform_keys { |key| key.to_s }
  end unless method_defined?(:stringify_keys)

  # Destructively convert all keys to strings. Same as
  # +stringify_keys+, but modifies +self+.
  def stringify_keys!
    transform_keys! { |key| key.to_s }
  end unless method_defined?(:stringify_keys!)

  # Returns a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+.
  #
  #   hash = { 'name' => 'Rob', 'age' => '28' }
  #
  #   hash.symbolize_keys
  #   # => { name: "Rob", age: "28" }
  def symbolize_keys
    transform_keys { |key| key.to_sym rescue key }
  end unless method_defined?(:symbolize_keys)

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+. Same as +symbolize_keys+, but modifies +self+.
  def symbolize_keys!
    transform_keys! { |key| key.to_sym rescue key }
  end unless method_defined?(:symbolize_keys!)

  # Returns a new hash with all keys converted by the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #  hash = { person: { name: 'Rob', age: '28' } }
  #
  #  hash.deep_transform_keys{ |key| key.to_s.upcase }
  #  # => {"PERSON"=>{"NAME"=>"Rob", "AGE"=>"28"}}
  def deep_transform_keys(&block)
    result = {}
    each do |key, value|
      result[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys(&block) : value
    end
    result
  end unless method_defined?(:deep_transform_keys)

  # Destructively convert all keys by using the block operation.
  # This includes the keys from the root hash and from all
  # nested hashes.
  def deep_transform_keys!(&block)
    keys.each do |key|
      value = delete(key)
      self[yield(key)] = value.is_a?(Hash) ? value.deep_transform_keys!(&block) : value
    end
    self
  end unless method_defined?(:deep_transform_keys!)

  # Returns a new hash with all keys converted to strings.
  # This includes the keys from the root hash and from all
  # nested hashes.
  #
  #   hash = { person: { name: 'Rob', age: '28' } }
  #
  #   hash.deep_stringify_keys
  #   # => {"person"=>{"name"=>"Rob", "age"=>"28"}}
  def deep_stringify_keys
    deep_transform_keys { |key| key.to_s }
  end unless method_defined?(:deep_stringify_keys)

  # Destructively convert all keys to strings.
  # This includes the keys from the root hash and from all
  # nested hashes.
  def deep_stringify_keys!
    deep_transform_keys! { |key| key.to_s }
  end unless method_defined?(:deep_stringify_keys!)

  # Returns a new hash with all keys converted to symbols, as long as
  # they respond to +to_sym+. This includes the keys from the root hash
  # and from all nested hashes.
  #
  #   hash = { 'person' => { 'name' => 'Rob', 'age' => '28' } }
  #
  #   hash.deep_symbolize_keys
  #   # => {:person=>{:name=>"Rob", :age=>"28"}}
  def deep_symbolize_keys
    deep_transform_keys { |key| key.to_sym rescue key }
  end unless method_defined?(:deep_symbolize_keys)

  # Destructively convert all keys to symbols, as long as they respond
  # to +to_sym+. This includes the keys from the root hash and from all
  # nested hashes.
  def deep_symbolize_keys!
    deep_transform_keys! { |key| key.to_sym rescue key }
  end unless method_defined?(:deep_symbolize_keys!)
end
