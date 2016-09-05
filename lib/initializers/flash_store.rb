module CrosstieInit
  class FlashStore
    def initialize(store = {})
      @store = store
    end

    def [](key)
      @store[key]
    end

    def []=(key, val)
      @store[key] = val
    end

    def to_json
      @store.to_json
    end
  end
end
