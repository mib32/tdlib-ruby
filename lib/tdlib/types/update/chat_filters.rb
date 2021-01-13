module TD::Types
  class Update::ChatFilters < Update
    attribute :chat_filters, TD::Types::Array.of(TD::Types::ChatFilterInfo)
  end
end
