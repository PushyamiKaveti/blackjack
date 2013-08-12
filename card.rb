
class Card
  SYMBOLS = [0, 'A', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A']
  def initialize(val, suit)
    @val = val
    @suit = suit
  end

  def val
    return 1 if @val == 14
    return 10 if @val > 10
    @val
  end

  def symbol
    SYMBOLS[@val].to_s
  end

  def ace?
    @val == 14
  end
end
