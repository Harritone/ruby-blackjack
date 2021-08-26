require_relative 'hand'

class Dealer < Hand
  attr_reader :name

  def initialize
    super
    @name = 'Dealer'
  end
end
