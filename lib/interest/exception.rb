module Interest
  class Exception < StandardError
    attr_accessor :original_exception

    def initialize(original_exception)
      self.original_exception = original_exception
      super()
    end
  end
end
