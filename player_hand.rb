class PlayerHand
  attr_accessor :num_cards, :cards
  def doubled=(val)
    @doubled = val
  end

  def doubled?
    @doubled
  end

  def get_bet
    @bet_amount
  end

  def remove_card
    self.num_cards -=  1
    cards[num_cards]
  end

  def add_card(card)
    cards[num_cards] = card
    self.num_cards += 1
  end
  def reset
     @num_cards=0
     @bet_amount=0
     @busted=0
     @doubled=0
  end
  def hand_value
    value=0
    flag=false
    for i in 0...num_cards
      value=value+cards[i].val
      if cards[i].ace?
        flag=true
      end
    end
    if flag && value <= 11
      value = value + 10
    end
    value
  end

  def busted?
    @busted = hand_value > 21
  end

  def display(ishidden=false)
    display= "cards: "
    i = 0
    if ishidden
      i = 1
      display = display + "hidden "
    end
    while i < num_cards
      display = display+cards[i].symbol+" "
      i += 1
    end
    display
  end

  def double_bet(amount)
    @bet_amount += amount
  end

  def initialize(bet)
    @bet_amount = bet
    @cards = Array.new(13)
    @num_cards = 0
    @busted = false
    @doubled = false
  end
end
