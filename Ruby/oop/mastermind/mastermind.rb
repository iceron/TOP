require_relative 'string/string'
require_relative 'components/peg'


class Key
  attr_accessor :red, :white
  def initialize red=0, white=0
    @red = red
    @white = white
  end
end

class Mastermind
  @@colors_list = ["red", "green", "yellow", "blue", "violet", "light_blue"]
  @@tile = "\u25A0 "
  def initialize turns=12
    @data = []
    i = 0
    while i < turns
      hash = {
        pegs: [nil, nil, nil, nil],
        key: nil
      }
      @data.push(hash.dup)
      i = i + 1
    end
    @index = 0
    generate_secret
    @codemaker_ai = true
    @solved = false
    @out_of_turns = false
  end

  def generate_secret
    @secret = []
    for i in 0...4 do
      valid = false
      while !valid
        color = @@colors_list.sample
        if !@secret.any? {|peg| peg.color == color}
          new_peg = Peg.new(color)
          @secret << new_peg
          valid = true
        end
      end
    end
  end

  def display
    @secret.each do |item|
      if @codemaker_ai
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

  def update
    red = 0
    white = 0
    @data[@index][:pegs].each_with_index do |peg, i|
      next if peg.nil?
      if peg.color == @secret[i].color
        red = red + 1
      elsif @secret.any? {|item| item.color == peg.color}
        white = white + 1
      end
    end
    @data[@index][:key] = Key.new(red, white)
  end

  def player_turn
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
        print "Enter color at slot ##{i+1}: "
        choice = gets.chomp
        choice.downcase!
        if @@colors_list.any? {|color| color == choice}
          if @data[@index][:pegs].any? {|peg| peg.color == choice rescue false}
            puts "No duplicates allowed, try again."
          else
            valid = true
          end
        else
          puts "Invalid input, try again."
        end
      end
      @data[@index][:pegs][i] = Peg.new(choice)
    end

  end

  def out_of_turns?
    result = !@data[@data.length-1][:key].nil?
    puts "Out of turns!" if result
    @out_of_turns = result
    result
  end

  def solved?
    result = false
    @data.each do |turn|
      result = turn[:key].red >= 4 if !turn[:key].nil?
      break if result == true
    end
    @solved = result
    result
  end

  def play
    initialize
    while true
      display
      player_turn
      update
      system "clear"
      break if solved? || out_of_turns?
      @index = @index + 1
    end
    update
    display
    puts "Combination is solved!" if @solved
    puts "Out of turns!" if @out_of_turns
    puts "Game ended."
  end

  def run
    run = true
    while run
      system "clear"
      puts "Let's play a game of Mastermind!"
      puts "Guess the combination of colors!"
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