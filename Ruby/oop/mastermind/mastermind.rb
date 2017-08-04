require_relative 'string/string'
require_relative 'components/peg'
require_relative 'components/key'
require_relative 'players/human'
require_relative 'players/computer'

class Mastermind
  @@colors_list = ["red", "green", "yellow", "blue", "violet", "light_blue"]
  @@tile = "\u25A0 "

  #initialize
  def initialize turns=12
    @turns = turns
  end

  #reset data for new game
  def reset
    generate_secret
    @solved = false
    @out_of_turns = false
    @index = 0
    @data = []
    i = 0
    while i < @turns
      hash = {
        pegs: [nil, nil, nil, nil],
        key: nil
      }
      @data.push(hash.dup)
      i = i + 1
    end
  end

  #generate new secret
  def generate_secret
    @secret = []
    @secret = @codemaker.generate_secret
  end

  #display the board
  def display
    @secret.each do |item|
      if @codemaker.class.name == "Computer"
        if @solved || @out_of_turns
          print @@tile.public_send(item.color)
        else
          print @@tile
        end
      else
        print @@tile.public_send(item.color)
      end
    end
    print "\n"
    out = ""
    @data.reverse_each do |turn|
      keys = ""
      if !turn[:pegs].nil?
        turn[:pegs].each do |peg|
          if !peg.nil?
            out = out + @@tile.public_send(peg.color)
          else
            out = out + @@tile
          end
        end
      else
        for i in 0...4 do
          out = out + @@tile
        end
      end
      if !turn[:key].nil? && turn[:pegs].all?
        count_red = turn[:key].red
        count_white = turn[:key].white
        keys = ((count_red.to_s.red)+":"+(count_white.to_s.white))
      end
      puts out + "     " + keys
      out = ""
    end
  end

  #update board data
  def update
    red, white = @codemaker.maker_input @secret, @data, @index
    @data[@index][:key] = Key.new(red, white)
  end

  #simulate player turn
  def player_turn
    if @index >=0 && @index < @turns
      @data[@index][:pegs].each_with_index do |peg, i|
        valid = false
        choice = ""
        if @index > 0 || i>0
          system "clear"
          display
        end
        print "Available colors: "
        @@colors_list.each {|x| print x + " "}
        print "\n"
        while !valid
          choice = @codebreaker.breaker_input i+1
          if @@colors_list.any? {|color| color == choice}
            if @data[@index][:pegs].any? {|peg| peg.color == choice rescue false}
              puts "No duplicates allowed, try again." if @codebreaker.class.name == "Human"
            else
              valid = true
            end
          else
            puts "Invalid input, try again." if @codebreaker.class.name == "Human"
          end
        end
        @data[@index][:pegs][i] = Peg.new(choice)
      end
    end
  end

  #returns true if no turns left, false otherwise
  def out_of_turns?
    result = !@data[@data.length-1][:key].nil?
    puts "Out of turns!" if result
    @out_of_turns = result
    result
  end

  #returns true if secret is solved, false otherwise
  def solved?
    result = false
    @data.each do |turn|
      result = turn[:key].red >= 4 if !turn[:key].nil?
      break if result == true
    end
    @solved = result
    result
  end

  #run a game
  def play
    while true
      display
      player_turn
      if @codemaker.class.name == "Human"
        system "clear"
        display
      end
      if solved? || out_of_turns?
        break
      else
        update
      end
      @index = @index + 1
    end
    system "clear"
    display
    puts "Combination is solved!" if @solved
    puts "Out of turns!" if @out_of_turns
    puts "Game ended."
  end

  #main method
  def run
    run = true
    while run
      system "clear"
      puts "Let's play a game of Mastermind!"
      puts "Guess the combination of colors!"
      option = nil
      while (option.nil?) || !(0..1).member?(option)
        puts "[0] - Become a code breaker"
        puts "[1] - Become a code maker"
        print "Select an option: "
        option = Integer(gets) rescue nil
        if option.nil?
          puts "Invalid input. Option should be an integer, try again."
          next
        end
        puts "Invalid input, try again." if not (0..1).member?(option)
      end
      if option == 0
        puts "You have chosen to be a code breaker!"
        @codemaker = Computer.new(false)
        @codebreaker = Human.new
      else
        puts "You have chosen to be a code maker!"
        @codemaker = Human.new(false)
        @codebreaker = Computer.new
      end

      reset
      play
      print "Play again (y/n)?: "
      choice = gets.chomp
      if (choice == "n" || choice == "N")
        run = false
      end
    end
  end
end

game = Mastermind.new
game.run
