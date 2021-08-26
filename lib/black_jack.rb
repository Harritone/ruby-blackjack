require_relative 'deck'
require_relative 'hand'

class BlackJack
  attr_reader :player, :dealer, :playing, :deck, :winner
attr_accessor :current_gamer, :result

  def initialize(suits, ranks)
    @player = nil
    @dealer = nil
    @winner = ''
    @deck = Deck.new(suits, ranks)
    @deck.shuffle
    @current_gamer = @player
    @result = ''
    @player_money = 100
    @dealer_money = 100
  end

  def player_can_take_card?
    player_cards = @player.dealt_cards
    return false unless player_cards.first.rank == '10' && player_cards.last.rank == 'Ace' ||
                       player_cards.first.rank == 'Ace' && player_cards.last.rank == '10'

    true
  end

  def handle_move(response)
    report = ''
    case response
    when 1
      report += 'You chose to hit:'
      hit
    when 2
      report += 'You chose to stand'
      stand
    end

    report += "\nPlayer's hand: #{@player}"
    report += "\nDealer's hand: #{@dealer}"
    take_bank
    report
  end


  def deal
    @player = Player.new
    @dealer = Dealer.new

    2.times do
      @dealer.add_card(@deck.deal_card)
      @player.add_card(@deck.deal_card)
    end
    @dealer.dealt_cards.first.show = false
    valuess_of_ten = %w[10 Jack Queen King]

    player_cards = @player.dealt_cards
    if valuess_of_ten.include?(player_cards.first.rank) &&
       player_cards.last.rank == 'Ace' ||
       player_cards.first.rank == 'Ace' &&
       valuess_of_ten.include?(player_cards.last.rank)

      @current_gamer = @dealer
    end
  end

  def hit
    if current_gamer == @player
      add_new_card @player
    else
      add_new_card @dealer
    end
  end

  def stand
    if @current_gamer == @player
      @current_gamer = @dealer
      @dealer.dealt_cards.first.show = true
    end
    while @dealer.get_value < 17
      self.hit
    end
  end

  def show_hands
    "Player's hand: #{@player}\nDealer's hand: #{@dealer}"
  end

  def check_deck
    @deck.replace if @deck.cards.count < 6
  end

  def check_balance
    if @dealer_money < 20
      'Dealer'
    elsif @player_money < 20
      'Player'
    end
  end

  def show_results
    case @winner
    when 'Tie'
      result = 'There is a tie, bank will be devided equaly.'
    when 'Player'
      result =  'Player has won!'
    when 'Dealer'
      result =  'Dealer has won!'
    end
    result += "\n#{show_hands}"
    result += "\nPlayer's money: #{@player_money}, Dealer's money: #{@dealer_money}"
    result
  end

  private

  def set_results
    if @player.get_value == @dealer.get_value
      @winner = 'Tie'
    elsif @player.get_value > 21
      @winner = 'Dealer'
    elsif @dealer.get_value > 21
      @winner = 'Player'
    elsif @player.get_value > dealer.get_value
      @winner = 'Player'
    else
      @winner = 'Dealer'
    end
    @dealer.dealt_cards.first.show = true
  end

  def take_bank
    set_results
    @player_money += @bank if @winner == 'Player'
    @dealer_money += @bank if @winner == 'Dealer'
    if @winner == 'Tie'
      @player_money += 20
      @dealer_money += 20
    end
    @bank = 0
  end

  def set_bank
    @bank = 40
    @player_money -= 20
    @dealer_money -= 20
  end

  def add_new_card(hand)
    hand.add_card(@deck.deal_card)
  end
end
