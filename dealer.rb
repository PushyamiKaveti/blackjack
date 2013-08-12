require './player'
require './player_hand'
class Dealer < Player

  def  initialize
    super "Dealer"
    create_hand
  end

  def create_hand
    hide
    @hand= PlayerHand.new(0)
  end

  def show_hidden
    @ishidden=false
  end

  def hide
    @ishidden=true
  end

  def hit (card)
    @hand.add_card(card)
  end

  def display
    display = name+"has \n"+ @hand.display(@ishidden)

  end

  def busted?
    return @hand.busted?
  end

  def num_cards
    return @hand.num_cards
  end
  def get_value
    return @hand.hand_value
  end

  def reset
    @ishidden = true
    @hand.reset
  end
end
