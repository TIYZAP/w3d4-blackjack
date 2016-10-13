class Card

  attr_accessor :suit, :face, :value

  def initialize(face, suit)
    self.face = face
    self.suit = suit
    card_value
  end

  def card_value
    if %w(King Queen Jack).include? face
      self.value = 10
    elsif face == "Ace"
      self.value = 11
    else
      self.value = face.to_i
    end
  end

  def to_s
    "the #{@face} of #{@suit}"
  end

  def > (other)
    value.to_i > other.value.to_i
  end

  def < (other)
    value.to_i < other.value.to_i
  end

end
