class Hand
  VALUES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'Jack' => 10,
    'Queen' => 10,
    'King' => 10,
    'Ace' => 1
  }.freeze
  attr_accessor :dealt_cards

  def initialize
    @dealt_cards = []
  end

  def add_card(card)
    @dealt_cards << card
  end

  def get_value
    card_ranks = @dealt_cards.map(&:rank)
    value = card_ranks.reduce(0) { |acc, rank| acc + VALUES[rank] }
    value += 10 if card_ranks.include?('Ace') && (value + 10 <= 21)
    value
  end

  def to_s
    report = ''
    dealt_cards.each { |card| report += "#{card}, " if card.show}
    if !dealt_cards.first.show
      first_value = VALUES[dealt_cards.first.rank]
      first_value += 10 if dealt_cards.first.rank == 'Ace'
      report + "Total value: #{get_value - first_value}"
    else
      report + "Total value: #{get_value}"
    end
  end
end
