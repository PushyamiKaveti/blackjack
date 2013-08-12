
class Player

  MAX_SPLITS=3;

  attr_reader :num_hands, :name,  :double_ace, :money

  def initialize(name)
    @name = name
    @money = 1000
    @hands = Array.new(4)  # Can split only thrice
    @num_hands=0
    @num_splits=0
    @double_ace=false
  end

  def create_hand(bet)
    @hands[@num_hands]=  PlayerHand.new(bet)
    @num_hands+=1
    @money = @money-bet
  end

  def split?
    @num_splits > 0
  end

  def split(hand_index)
    @num_splits +=1
    create_hand(@hands[hand_index].get_bet)
    card = @hands[hand_index].remove_card
    hit((@num_hands-1), card)
  end

  def splittable?(hand_index)
    if @hands[hand_index].num_cards == 2
      cards = @hands[hand_index].cards
      return true if cards[0].val==cards[1].val && @num_splits<3 && !@hands[hand_index].doubled?
    end
    return false
  end

  def remove_card(hand_index)
    return @hands[hand_index].remove_card
  end

  def get_bet(hand_index)
    return @hands[hand_index].get_bet
  end

  def hit(hand_index, card)
    if hand_index < @num_hands
      @hands[hand_index].add_card(card)
    end
  end



  def reset
    @num_hands=0
    @num_splits=0
    @double_ace=0
    for hand in @hands
      hand.reset if hand
    end
  end

  def get_value(hand_index)
    return @hands[hand_index].hand_value
  end

  def num_cards(hand_index)
    @hands[hand_index].num_cards
  end

  def busted?(hand_index)
    @hands[hand_index].busted?
  end

  def  display
    i=0
    display = @name+" has "+@num_hands.to_s+" hands \n"
    while i < @num_hands
      display = display +"Hand "+(i+1).to_s+"\n"+ @hands[i].display+"\n"
      i+=1
    end

    return display
  end

  def double_bet(hand_index)
    bet = @hands[hand_index].get_bet
    @money -= bet
    @hands[hand_index].double_bet(bet)
    @hands[hand_index].doubled = true
  end

  def can_double(hand_index)
    return @hands[hand_index].num_cards == 2
  end

  def check_double_ace(hand_index)
    i =0
    ace=0
    cards = @hands[hand_index].cards
    while i < @hands[hand_index].num_cards
      if cards[i].ace?
        ace+=1
      end
      i+=1
    end
    @double_ace = true if ace == 2
  end

  def push(hand_index)
    get = @hands[hand_index].get_bet
    @money= @money+ get
    return get
  end

  def win(hand_index, isBlkjk)
    if isBlkjk
      win= (3/2)*@hands[hand_index].get_bet
    else
      win = @hands[hand_index].get_bet
    end
    @money = @money + @hands[hand_index].get_bet + win
    return win
  end
end
