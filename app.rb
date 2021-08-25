require_relative './lib/black_jack'
class App
  SUITS = %w[Spades Hearts Clubs Diamonds].freeze
  RANKS = %w[2 3 4 5 6 7 8 9 10 Jack Queen King Ace].freeze

  def initialize
    @game = BlackJack.new(SUITS, RANKS)
    greeting
    start_game
  end

  def start_game
    @game.set_bank
    @game.deal
    puts @game.show_hands
    response = ask_move
    @game.handle_move(response)
    puts @game.show_results
    @game.ask_again
  end

  private

  def greeting
    system('clear')
    puts 'Hello! Welcome to BlackJack game!'
    puts
  end

  def say_bye_and_quit
    puts
    puts "Bye! It's been great pleasure to play with you!"
    puts
    exit 0
  end

  def ask_again
    has_no_money?(@game.check_balance)
    @game.check_deck
    puts
    puts "Player's money: #{@game.player_money}"
    puts "Dealer's money: #{@game.dealer_money}"
    puts "Bank: #{@bank}"
    puts 'Do you want to play another round?'
    puts 'Yes(1) No(2)'
    puts
    response = gets.chomp
    if response == '1'
      self.start_game
    else
      self.say_bye_and_quit
    end
  end

  def has_no_money?(player)
    return unless player

    puts 'You have no money to proceed.' if player == 'Player'
    puts 'Dealer has no money to proceed.' if player == 'Dealer'
    sleep(1)
    self.say_bye_and_quit
  end

  def ask_move
    if @game.player_can_take_card?
      'stand'
    else
      gets.chomp.to_i
    end
  end
end
