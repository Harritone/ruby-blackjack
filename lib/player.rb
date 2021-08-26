require_relative 'hand'

class Player < Hand
  attr_reader :name

  def initialize
    super
    @name = 'Player'
  end
end
