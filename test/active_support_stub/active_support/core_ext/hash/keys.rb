STUBBED_ACTIVE_SUPPORT_HASH_KEYS_EXTENSIONS = true

class Hash
  STUBS = [
    :transform_keys, :transform_keys!,
    :stringify_keys, :stringify_keys!,
    :symbolize_keys, :symbolize_keys!,
    :deep_transform_keys, :deep_transform_keys!,
    :deep_stringify_keys, :deep_stringify_keys!,
    :deep_symbolize_keys, :deep_symbolize_keys! ]

  def rofl; :trololo end
  STUBS.each { |stub| alias_method stub, :rofl }
end
