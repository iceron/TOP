require_relative 'player'

class Computer < Player
  def generate_secret
    secret = []
    for i in 0...4 do
      valid = false
      while !valid
        color = @@colors_list.sample
        if !secret.any? {|peg| peg.color == color}
          new_peg = Peg.new(color)
          secret << new_peg
          valid = true
        end
      end
    end
    secret
  end

  def breaker_input index
    @@colors_list.sample
  end

  def maker_input secret, data, index
    red = 0
    white = 0
    data[index][:pegs].each_with_index do |peg, i|
      next if peg.nil?
      if peg.color == secret[i].color
        red = red + 1
      elsif secret.any? {|item| item.color == peg.color}
        white = white + 1
      end
    end
    return red, white
  end
end
