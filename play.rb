require './deck'
require './dealer'
require './ui'
require './player'
require './player_hand'

class PlayBlackJack

  attr_accessor :players, :deck, :dealer, :num_players, :round_players, :ui
  #//constructor to initialize the game variables
  def initialize
    @num_players = 0
    @round_players=0
    @deck = Deck.new
    @dealer = Dealer.new
    @players = []
    @ui = UserInterface.new
  end
  #// sets the number of players in the game
  def set_players(num)
    @num_players=num
    for  i in 0...@num_players
      @players[i] = Player.new(@ui.get_player_name(i+1))
    end
  end
  def deal_cards
    if !@deck.sufficient?(@round_players)
      #  //deck ==null condition add if necessary
      @deck = Deck.new
      @deck.shuffle_cards
    end
    for player in @players
      if player.num_hands != 0
        player.hit(0, @deck.deal_card)
        player.hit(0, @deck.deal_card)
        player.check_double_ace(0)
      end
    end
    @dealer.hit(@deck.deal_card)
    @dealer.hit(@deck.deal_card)
  end


  # //condition for black jack and push are to be implemented
  def who_wins

    bj = false
    bust = false
    #//Check for dealer status after the showing hands
    if @dealer.busted?
      @ui.message("dealer loses")
      bust=true
    else
      if @dealer.get_value == 21 && @dealer.num_cards == 2
        bj=true
      end
    end

    #//Check for player status after showing hands

    for  player in @players
      hand_index = 0
      while hand_index < player.num_hands
        if player.busted?(hand_index)
          ui.message(player.name+"loses on hand"+ (hand_index+1).to_s)
        else
          if player.get_value(hand_index) == 21 && player.num_cards(hand_index) == 2 && !player.split?
            if BJ == true
              @ui.message(player.name+" and dealer has a black jack!!! its a push on hand"+ (hand_index+1).to_s)
              @ui.message(player.name+"gets back "+ player.push(hand_index).to_s)
            else
              @ui.message(" its a black jack!!!"+player.name+" wins on hand"+ (hand_index+1).to_s)
              @ui.message(player.name+"gets "+player.win(hand_index,true).to_s)
            end
          else
            if !bust
              if player.get_value(hand_index) > @dealer.get_value
                @ui.message(player.name+" wins on hand"+ (hand_index+1).to_s+"!!!")
                @ui.message(player.name+"gets "+player.win(hand_index,false).to_s)
              elsif player.get_value(hand_index) == dealer.get_value
                @ui.message("Its a push on hand"+ (hand_index+1).to_s+"!!!"+player.name+" and dealer has same value.")
                @ui.message(player.name+"gets back "+ player.push(hand_index).to_s)
              else
                @ui.message(player.name+" loses on hand"+ (hand_index+1).to_s)
              end
            else
              @ui.message(player.name+" wins on hand"+ (hand_index+1).to_s+"!!!")
              @ui.message(player.name+"gets "+player.win(hand_index,false).to_s)
            end
          end
        end
        hand_index+=1
      end
    end
  end



  def dealer_hits
    # TODO Auto-generated method stub
    while @dealer.get_value < 17
      @dealer.hit(@deck.deal_card)
    end
    @dealer.busted?

  end
  def player_decisions
    # TODO Auto-generated method stub
    for player in @players
      flag = true
      hand_index=0
      num_hands = player.num_hands
      while hand_index < num_hands
        while flag && !player.busted?(hand_index)
          decision = @ui.get_decision(player,hand_index)
          case decision
          when "h"
            if(player.double_ace)
              flag=false
            else
              player.hit(hand_index, @deck.deal_card)
            end
          when "s"
            flag=false
          when "p"
            if player.splittable?(hand_index)
              #int bet = player.get_Bet(hand_index)/2
              player.split(hand_index)
              for  i in 0...player.num_hands
                player.hit(i, @deck.deal_card)# suficient condition of deal card must be changed
              end
            else
              @ui.message("split not possible! try again")
            end
          when "d"
            if player.double_ace
              flag=false
            else
              if player.can_double(hand_index)
                player.double_bet(hand_index)
                player.hit(hand_index, @deck.deal_card)
                flag=false
              else
                @ui.message("Doubling not possible")
              end
            end
          else
            @ui.message("Invalid choice! try again")
          end
          @ui.display_cards(player)
        end
        if flag
          @ui.message(player.name+"'s hand busted\n")
        end
        hand_index+=1
      end
    end

  end

  def eliminate_and_reset
    @players.delete_if do |player|
      puts "#{player.name} has insufficient money" if player.money <= 0
      player.money <= 0
    end
    @players.each do |player|
      player.reset
    end
    @dealer.reset
  end

end



#Start the black jack Game Give a welcome mesg to the user
pbj = PlayBlackJack.new
#displays welcome message and returns num of players
mesg = pbj.ui.start_game
exit=false;
pbj.set_players(mesg)
#shuffle the deck before starting the game
# start asking for bets and get the number of players in the current round
begin 
  pbj.round_players = pbj.ui.get_player_bets(pbj.players)

  pbj.deck.shuffle_cards
  if pbj.round_players == 0
    pbj.ui.message("No Players in the current round")
    pbj.ui.quit_game
  end
  pbj.deal_cards

  #display all the cards of the players and face up card of the dealer to let players make decisions
  pbj.ui.display_cards(pbj.players,pbj.dealer)

  #Ask for players decisions..

  pbj.player_decisions

  pbj.dealer.show_hidden
  pbj.ui.display_cards(pbj.players, pbj.dealer)
  pbj.dealer_hits
  pbj.ui.display_cards(pbj.dealer)
  pbj.who_wins
  pbj.eliminate_and_reset
end until pbj.ui.exit? || pbj.players.empty?

if pbj.players.empty?
  pbj.ui.message("End of game . No more players")
end
pbj.ui.quit_game

