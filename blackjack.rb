require_relative "card"
require_relative "deck"


class Blackjack

  include Comparable

  attr_accessor :player_hand, :cpu_hand, :player_score, :cpu_score, :bjdeck

  def initialize
    puts "Beat the Dealer --- Blackjack"
    self.player_hand = []
    self.cpu_hand = []
    self.player_score = 0
    self.cpu_score = 0
    self.bjdeck = Deck.new
    bjdeck.shuffle
  end

  def deal
    hit = bjdeck.draw
    self.player_hand << hit
    hit = bjdeck.draw
    self.cpu_hand << hit
  end

  def start_cards
    puts "Dealer #{hand_simp(cpu_hand.drop(1))}"
    puts "Player #{hand_simp(player_hand)}"
  end

  def show_cards
    puts "Dealer #{hand_simp(cpu_hand)}"
    puts "Player #{hand_simp(player_hand)}"
  end

  def hand_simp(hand)
    hand = hand.collect
    hand.each { |card| card.to_s }.join(",")
  end

  def play
    2.times { deal }
    start_cards
    if player_hand.collect{|x| x.value}.inject(:+) == 21
      natural
    elsif cpu_hand.collect{|x| x.value}.inject(:+) == 21
      natural
    else
      turn
    end
  end


  def turn
    puts "Would you like to HIT or STAY?!"
    answ = gets.chomp.downcase
    until answ == "hit" || answ == "stay"
      puts "Do you want me to call the pit boss?! HIT or STAY??"
      answ = gets.chomp.downcase
    end

    if answ == "hit"
      hit = bjdeck.draw
      player_hand << hit
      show_cards
      if player_hand.collect{|x| x.value}.inject(:+) > 21
        puts "BUST! --- You Lose!"
        bust
      else
        turn
      end
    else
      cpu_turn
    end
  end

  def cpu_turn
    puts "and the Dealers hand is...? Press [Enter]"
    gets.chomp
    until cpu_hand.collect{|x| x.value}.inject(:+) > 16
      puts "Dealer HITS!"
      hit = bjdeck.draw
      cpu_hand << hit
      show_cards
    end

    if cpu_hand.collect{|x| x.value}.inject(:+)  > 21
      puts "Dealer BUST!"
      bank
    else
      show_cards
      if player_hand.collect{|x| x.value}.inject(:+) > cpu_hand.collect{|x| x.value}.inject(:+)
        bank
      elsif cpu_hand.collect{|x| x.value}.inject(:+) > player_hand.collect{|x| x.value}.inject(:+)
        bust
      else
        bank
      end
    end
  end

  def bank
    puts "You WIN! --- Your in the MONEY!"
    new_game
  end

  def natural
    puts "21! Blackjack! --- Your in the MONEY!"
    new_game
  end

  def bust
    puts "The house ALWAYS WINS! --- You LOSE!"
    new_game
  end

  def new_game
    puts "Continue? (y/n)"
    answ = gets.chomp.downcase
    until answ == "y" || answ == "n"
      puts "I think you've had too much to drink. Do you want to play? (y/n)"
      answ = gets.chomp.downcase
    end

    if answ == "y"
      puts ""
      initialize
      play
    else answ == "n"
      puts "The house ALWAYS WINS! --- come back when you have more money!"
    end
  end
end

Blackjack.new.play
