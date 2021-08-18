require_relative 'card'

class Deck
  attr_reader :suits, :ranks, :cards

  def initialize(ranks, suits)
    @cards = []
    @ranks = ranks
    @suits = suits
    create_deck!
  end

  def shuffle
    @cards.shuffle!
  end

  def replace
    @cards = []
    create_deck!
  end

  def deal_card
    @cards.pop
  end

  private

  def create_deck!
    @suits.each do |suit|
      ranks.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
  end
end
