require_relative 'card'
require_relative 'deck'

class Blackjack
  include Comparable

  attr_accessor :player_hand, :cpu_hand, :player_score, :cpu_score, :bjdeck

  def initialize
    puts 'Beat the Dealer --- Blackjack'
    self.player_hand = []
    self.cpu_hand = []
    self.player_score = 0
    self.cpu_score = 0
    self.bjdeck = Deck.new
    bjdeck.shuffle
  end

  def deal
    hit = bjdeck.draw
    player_hand << hit
    hit = bjdeck.draw
    cpu_hand << hit
  end

  def start_cards
    puts "Dealer #{hand_simp(cpu_hand.drop(1))}"
    puts "Player #{hand_simp(player_hand)}"
  end

  def show_cards
    # "score" is now being used in place of show_cards /
    # use show_cards for simple versoin!
    puts "Dealer #{hand_simp(cpu_hand)}"
    puts "Player #{hand_simp(player_hand)}"
  end

  def hand_simp(hand)
    hand.collect(&:to_s).join(',')
  end

  def play
    2.times { deal }
    start_cards
    if player_hand.collect(&:value).inject(:+) == 21
      natural
    elsif player_hand.collect(&:value).inject(:+) > 21
      bust
    elsif cpu_hand.collect(&:value).inject(:+) > 21
      score
      bank
    elsif cpu_hand.collect(&:value).inject(:+) == 21
      score
      natural_lose
    else
      turn
    end
  end

  # Keith's new Player Methods start below-------------------------
  def player_hand_total_value
    player_hand.collect(&:value).inject(:+)
  end




  def turn
    if player_hand.collect(&:value).inject(:+) < 21 && player_hand.length == 6
      under
    else
      puts 'Would you like to HIT or STAY?!'
      answ = gets.chomp.downcase
      until answ == 'hit' || answ == 'stay'
        puts 'Do you want me to call the pit boss?! HIT or STAY??'
        answ = gets.chomp.downcase
      end
    end

    if answ == 'hit'
      hit = bjdeck.draw
      player_hand << hit
      score
      if player_hand_total_value == 21
        natural
      elsif player_hand_total_value > 21
        puts 'BUST! --- You Lose!'
        bust
      else
        turn
      end
    else
      cpu_turn
    end
  end

  def cpu_turn
    puts 'and the Dealers hand is...? Press [Enter]'
    gets.chomp
    until cpu_hand.collect(&:value).inject(:+) > 16
      puts 'Dealer HITS!'
      hit = bjdeck.draw
      cpu_hand << hit
      score
    end

    if cpu_hand.collect(&:value).inject(:+) == 21
      natural_lose
      score

    elsif cpu_hand.collect(&:value).inject(:+) > 21
      puts 'Dealer BUST!'
      bank
    else
      score
      if player_hand_total_value > cpu_hand.collect(&:value).inject(:+)
        bank
      elsif cpu_hand.collect(&:value).inject(:+) > player_hand.collect(&:value).inject(:+)
        bust
      else
        puts 'DRAW!! --- Who has the most cards?'
        x = player_hand.length
        y = cpu_hand.length
        puts "Player = #{x} cards, House = #{y}."
        if cpu_hand.length < player_hand.length
          bank
        elsif cpu_hand.length > player_hand.length
          bust
        else
          puts 'True DRAW!! --- Your in the MONEY!'
          bank
        end
      end
    end
  end

  def bank
    puts 'You WIN! --- Your in the MONEY!'
    new_game
  end

  def natural
    puts '21! Blackjack! --- Your in the MONEY!'
    new_game
  end

  def natural_lose
    puts 'Dealer hits 21! Blackjack! --- You LOSE!'
    new_game
  end

  def bust
    puts 'The house ALWAYS WINS! --- You LOSE!'
    new_game
  end

  def under
    puts 'Six cards - and your under 21! - YOU WIN!'
    new_game
  end

  def score
    player_score = player_hand_total_value
    cpu_score = cpu_hand.collect(&:value).inject(:+)
    puts "Player = #{player_hand.collect { |x| "#{x.face} of #{x.suit}" }.join(' + ')}, Total = #{player_score}"
    puts "House = #{cpu_hand.collect { |x| "#{x.face} of #{x.suit}" }.join(' + ')}, Total = #{cpu_score}"
    puts ''
  end

  def new_game
    puts 'Continue? (y/n)'
    answ = gets.chomp.downcase
    until answ == 'y' || answ == 'n'
      puts "I think you've had too much to drink. Do you want to play? (y/n)"
      answ = gets.chomp.downcase
    end

    if answ == 'y'
      puts ''
      initialize
      play
    elsif answ == 'n'
      puts 'The house ALWAYS WINS! --- come back when you have more money!'
      exit
    end
  end
end

Blackjack.new.play
