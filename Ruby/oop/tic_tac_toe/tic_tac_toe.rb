class Tic_tac_toe
  #set player tokens
  @@player1 = "x"
  @@player2 = "o"

  #initialization
  def initialize
    @data = ('0'...'9').to_a
    @player1_turn = true
  end

  #check if value is of type int
  def integer?(value)
    Integer(value) != nil rescue false
  end

  #show the board
  def display
    @out = ""
    @row = 0
    @data.each_with_index do |x, i|
      @out = @out + x
      if (i + 1) % 3 == 0
        puts @out
        if @row <= 1
          puts "---------"
          @row = @row + 1
        end
        @out = ""
      else
        @out = @out + " | "
      end
    end
  end

  #check if a cell is already taken
  def taken?(choice)
    @data[choice] == @@player1 || @data[choice] == @@player2
  end

  #update the data (board)
  def update(choice, input)
    result = false
    if !taken?(choice)
      @data[choice] = input
      result = true
    end
    result
  end

  #check for row pattern match
  def row_pattern?(start, input)
    [@data[start], @data[start+1], @data[start+2]].all?{|word| word == input}
  end

  #check for column pattern match
  def column_pattern?(start, input)
    [@data[start], @data[start+3], @data[start+6]].all?{|word| word == input}
  end

  #check for diagonal pattern match
  def diagonal_pattern?(start, input)
    result = false
    if start == 0
      result = [@data[start], @data[start+4], @data[start+8]].all?{|word| word == input}
    elsif start == 2
      result = [@data[start], @data[start+2], @data[start+4]].all?{|word| word == input}
    end
    result
  end

  #check for pattern match
  def pattern_match?(input)
    row_pattern?(0, input) || row_pattern?(3, input) || row_pattern?(6, input) ||
    column_pattern?(0, input) || column_pattern?(1, input) || column_pattern?(2, input) ||
    diagonal_pattern?(0, input) || diagonal_pattern?(2, input)
  end

  #check if player won
  def player_win?
    result = false
    if pattern_match?(@@player1)
      system "clear"
      puts "Player 1 won!"
      result = true
    elsif pattern_match?(@@player2)
      system "clear"
      puts "Player 2 won!"
      result = true
    end
    result
  end

  #check if board is full
  def board_full?
    result = false
    if @data.all?{|item| item == @@player1 || item == @@player2}
      result = true
      puts "The board is full. Game ended."
    end
    result
  end

  #run a player's turn
  def player_turn
    system "clear"
    display
    player_id = @player1_turn ? '1' : '2'
    player_input = @player1_turn ? @@player1 : @@player2
    begin
      print "Player #{player_id}'s turn ('#{player_input}'): "
      choice  = gets.chomp
      result = false
      if !integer?(choice)
        puts "Input should be an integer, try again."
      elsif choice.to_i < 0 || choice.to_i > 8
        puts "Invalid input, try again."
      else
        result = update(choice.to_i, player_input)
        if !result
          puts "Choice is taken, try again."
        end
      end
    end until result == true
    @player1_turn ^= true
  end

  #play a game
  def play
    while true
      player_turn
      break if player_win? || board_full?
    end
    display
  end

  #main sequence
  def run
    run = true
    display
    puts "This is a game of tic-tac toe."
    puts "Two players take turns in placing their tokens on the board."
    puts "The cells on the board are numbered accordingly."
    print "To begin, press enter."
    gets.chomp
    begin
      initialize
      play
      print "Play again (y/n)?: "
      choice = gets.chomp
      if (choice == "n" || choice == "N")
        run = false
      end
    end until run == false
  end

end

game = Tic_tac_toe.new
game.run
