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
    @player_money = 100
    @dealer_money = 100
  end

  def start
    @current_gamer = 'Player'
    set_bank_and
    deal
    puts show_hands
    player_cards = @player_hand.dealt_cards
    unless player_cards.first.rank == '10' && player_cards.last.rank == 'Ace' ||
            player_cards.first.rank == 'Ace' && player_cards.last.rank == '10'
      puts 'Do you want to hit(1) or to stand(2)?'
      response = gets.chomp.to_i

      if response == 1
        puts 'You chose to hit:'
        hit
        puts "Player's hand: #{@player_hand}"
        puts "Dealer's hand: #{@dealer_hand}"
        puts
      elsif response == 2
        puts 'You chose to stand'
        stand
        puts "Player's hand: #{@player_hand}"
        puts "Dealer's hand: #{@dealer_hand}"
        puts
      end
    else
      stand
      puts "Player's hand: #{@player_hand}"
      puts "Dealer's hand: #{@dealer_hand}"
      puts
    end
    take_bank
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

  def ask_again
    puts
    check_balance_and_deck
    puts "Player's money: #{@player_money}"
    puts "Dealer's money: #{@dealer_money}"
    puts "Bank: #{@bank}"
    puts 'Do you want to play another round?'
    puts 'Yes(1) No(2)'
    puts
    response = gets.chomp
    if response == '1'
      self.call
    else
      exit 0
    end
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

  def check_balance_and_deck
    if @deck.cards.count < 6
      @deck.replace
    end
    if @dealer_money < 20
      has_no_money('Dealer')
    elsif @player_money < 20
      has_no_money('Player')
    end
  end

  def has_no_money(staker)
    puts
    puts "#{staker} has no money to continue!"
    exit 0
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
