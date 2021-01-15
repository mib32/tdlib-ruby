class TD::UpdateHandler
  include Concurrent::Async

  attr_reader :update_type, :extra

  def initialize(update_type, extra = nil, parse_json: true, disposable: false, &action)
    super()

    @action = action
    @update_type = update_type
    @extra = extra
    @disposable = disposable
    @parse_json = parse_json
  end

  def run(update)
    if @parse_json
      action.call(TD::Types.wrap(JSON.parse(update[:raw])) )
    else
      action.call(update)
    end
  end

  def match?(update, extra = nil)
    # byebug if update_type == TD::Types::Update::AuthorizationState
    (update[:type].is_a?(Class) ? update[:type] <= update_type : update[:type] == update_type ) && (self.extra.nil? || self.extra == extra)
  end

  def disposable?
    disposable
  end

  def to_s
    "TD::UpdateHandler (#{update_type}#{": #{extra}" if extra})#{' disposable' if disposable?}"
  end

  alias inspect to_s

  private

  attr_reader :action, :disposable
end
