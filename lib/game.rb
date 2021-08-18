require_relative 'black_jack'

class Game
  SUITS = ['Spades', 'Hearts', 'Clubs', 'Diamonds'].freeze
  RANKS = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'].freeze

  def initialize
    @blackjack = BlackJack.new(SUITS, RANKS)
    @bank = 0
    @player_money = 100
    @dealer_money = 100
    @winner = ''
    greeting
    self.call
  end

  def call
    @blackjack.current_gamer = 'Player'
    @bank = 40
    @player_money -= 20
    @dealer_money -= 20
    @blackjack.deal
    puts @blackjack.show_hands
    player_cards = @blackjack.player_hand.dealt_cards
    unless player_cards.first.rank == '10' && player_cards.last.rank == 'Ace' ||
            player_cards.first.rank == 'Ace' && player_cards.last.rank == '10'
      puts 'Do you want to hit(1) or to stand(2)?'
      response = gets.chomp.to_i

      if response == 1
        puts 'You chose to hit:'
        @blackjack.hit
        puts "Player's hand: #{@blackjack.player_hand.to_s}"
        puts "Dealer's hand: #{@blackjack.dealer_hand.to_s}"
        puts
      elsif response == 2
        puts 'You chose to stand'
        @blackjack.stand
        puts "Player's hand: #{@blackjack.player_hand.to_s}"
        puts "Dealer's hand: #{@blackjack.dealer_hand.to_s}"
        puts
      end
    else
      @blackjack.stand
      puts "Player's hand: #{@blackjack.player_hand.to_s}"
      puts "Dealer's hand: #{@blackjack.dealer_hand.to_s}"
      puts
    end
    take_bank
    show_results
    ask_again
  end

  private

  def show_results
    puts
    winner = @blackjack.winner
    if winner == 'Dealer'
      puts "The winner is #{@blackjack.winner}!"
      puts "With #{@blackjack.dealer_hand}"
      puts "Player: #{@blackjack.player_hand}"
    elsif winner == 'Player'
      puts "The winner is #{@blackjack.winner}!"
      puts "With #{@blackjack.player_hand}"
      puts "Dealer: #{@blackjack.dealer_hand}"
    else
      puts 'There is a tie! Bank will be devided equally!'
      puts "Dealer: #{@blackjack.dealer_hand}"
      puts "Player: #{@blackjack.player_hand}"
    end
    puts
  end

  def take_bank
    @blackjack.set_results
    @player_money += @bank if @blackjack.winner == 'Player'
    @dealer_money += @bank if @blackjack.winner == 'Dealer'
    if @blackjack.winner == 'Tie'
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

  def check_balance_and_deck
    if @blackjack.deck.cards.count < 6
      @blackjack.deck.replace
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

  def greeting
    system('clear')
    puts 'Hello! Welcome to BlackJack game!'
    puts
  end
end
