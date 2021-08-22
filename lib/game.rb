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
    @blackjack.start
    @blackjack.take_bank
    @blackjack.show_results
    @blackjack.ask_again
  end

  private

  def greeting
    system('clear')
    puts 'Hello! Welcome to BlackJack game!'
    puts
  end
end
