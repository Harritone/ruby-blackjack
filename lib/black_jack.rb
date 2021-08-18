require_relative 'deck'
require_relative 'hand'

class BlackJack
  attr_reader :player_hand, :dealer_hand, :playing, :deck, :winner
  attr_accessor :current_gamer, :result

  def initialize(suits, ranks)
    @player_hand = nil
    @dealer_hand = nil
    @suits = suits
    @ranks = ranks
    @winner = ''
    @deck = Deck.new(suits, ranks)
    @deck.shuffle
    @current_gamer = 'Player'
    @result = ''
  end

  def deal
    @player_hand = Hand.new
    @dealer_hand = Hand.new

    2.times do
      dealer_hand.add_card(@deck.deal_card)
      player_hand.add_card(@deck.deal_card)
    end
    dealer_hand.dealt_cards.first.show = false
    valuess_of_ten = %w[10 Jack Queen King]

    player_cards = player_hand.dealt_cards
    if valuess_of_ten.include?(player_cards.first.rank) &&
       player_cards.last.rank == 'Ace' ||
       player_cards.first.rank == 'Ace' &&
       valuess_of_ten.include?(player_cards.last.rank)

      @current_gamer = 'Dealer'
    end
  end

  def hit
      if current_gamer == 'Player'
        add_new_card @player_hand
      else
        add_new_card @dealer_hand
      end
  end

  def stand
      if current_gamer == 'Player'
        @current_gamer = 'Dealer'
        @dealer_hand.dealt_cards.first.show = true
      end
      while @dealer_hand.get_value < 17
        self.hit
      end
  end

  def show_hands
    "Player's hand: #{@player_hand}\nDealer's hand: #{@dealer_hand}"
  end

  def set_results
    if player_hand.get_value == dealer_hand.get_value
      @winner = 'Tie'
    elsif player_hand.get_value > 21
      @winner = 'Dealer'
    elsif dealer_hand.get_value > 21
      @winner = 'Player'
    elsif player_hand.get_value > dealer_hand.get_value
      @winner = 'Player'
    else
      @winner = 'Dealer'
    end
    @dealer_hand.dealt_cards.first.show = true
  end

  private

  def add_new_card(hand)
    hand.add_card(@deck.deal_card)
  end
end