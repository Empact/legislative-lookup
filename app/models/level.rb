class Level
  LEVELS = {
    'federal' => {
      :fill_color => 'red',
      :stroke_color => 'gray',
      :description => 'Congressional District',
      :sort_order => 1
    },
    'state_upper' => {
      :fill_color => 'green',
      :stroke_color => 'gray',
      :description => 'Upper House District',
      :sort_order => 2
    },
    'state_lower' => {
      :fill_color => 'blue',
      :stroke_color => 'gray',
      :description => 'Lower House District',
      :sort_order => 3
    }
  }

  class << self
    def levels
      LEVELS.keys
    end
  end

  def initialize(level)
    @level = level
  end

  def method_missing(method, *args)
    @attrs ||= LEVELS.fetch(level)
    @attrs.fetch(method.to_sym)
  end

  attr_reader :level
  alias_method :to_s, :level
  delegate :to_sym, :to => :level
end
