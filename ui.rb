class UserInterface
  def start_game
    puts("Welcome to BlackJack! ! ! ")
    puts("Wanna play Black Jack? Please enter the number of players");
    puts("Else press '0' to quit")
    num = STDIN.readline.to_i
    quit_game if num == 0
    num
  end

  def quit_game
    puts("Quitting Black Jack!!! Bye Bye")
    exit(0)
  end

  def get_player_name(playernum)
    puts("Enter the name of Player "+playernum.to_s)
    STDIN.readline.chomp
  end

  def get_player_bets(players)
    round_players = 0
    puts("Start Betting")
    for player in players
      puts(player.name+", Placing yor bet? [y]/[N]")
      nextline = STDIN.readline.chomp
      if nextline.downcase == "y"
        puts("Please enter the bet amount")
        nextline = STDIN.readline.chomp
        player.create_hand(nextline.to_i)
        round_players += 1
      end
    end
    round_players
  end

  def display_cards(players, dealer=nil)
    puts("Cards after deal")
    players = Array(players)
    for player in players
      puts player.display
    end
    puts dealer.display if dealer
  end

  def get_decision(player, hand_index)
    puts(player.name+", Please choose an option for hand "+hand_index.to_s)
    puts("H-hit\nS-stand\nP-Split\n\nD-double")
    STDIN.readline.chomp
  end

  def message(error)
    puts(error)
  end
  def exit?
    puts("End od round !! Wanna play another game? press [Y] \n exit? press[X]")
    nextline = STDIN.readline.chomp
    nextline.downcase == "x"
  end
end
