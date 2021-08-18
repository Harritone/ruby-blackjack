class Card
  class ValidationError < StandardError; end
  attr_reader :suit, :rank
  attr_accessor :show

  SUITS = %w[Spades Hearts Clubs Diamonds].freeze
  RANKS = %w[1 2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze

  def initialize(suit, rank)
    @show = true
    @rank = rank
    @suit = suit
    validate_attributes
  end

  def to_s
    @show ? "#{@rank} of #{@suit}" : ''
  end

  private

  def validate_attributes
    raise ValidationError unless SUITS.include?(@suit) &&
                                 RANKS.include?(@rank)
  end
end
