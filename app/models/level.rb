class Level
  LEVELS = {
    'federal' => {
      :color => 'red',
      :description => 'Congressional District',
    },
    'state_upper' => {
      :color => 'green',
      :description => 'Upper House District'
    },
    'state_lower' => {
      :color => 'blue',
      :description => 'Lower House District'
    }
  }

  class << self
    def levels
      LEVELS.keys
    end
  end

  def initialize(level)
    @level = level
    attrs = LEVELS.fetch(level)
    @color = attrs[:color]
    @description = attrs[:description]
  end

  attr_reader :color, :description, :level
end
