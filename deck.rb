require './card'

class Deck 
  attr_reader  :num_cards
  def initialize
    temp=0
    @num_cards = 52
    @cards = Array.new(52)
    for suit in 0...4 
      for val  in 2...15 
        @cards[temp] = Card.new(val, suit)
        temp +=1
        #System.out.println(temp)
      end
    end
  end
  def sufficient?(round_players)
    @num_cards >= round_players*6  #need to set the threshold according to number of players
  end
  def shuffle_cards 
    for i in 0...@num_cards
      index = rand(i) 
      temp = @cards[i]
      @cards[i]  = @cards[index];
      @cards[index]  = temp;
    end
  end

  def deal_card
    @num_cards-=1
    return @cards[@num_cards]
  end
end
