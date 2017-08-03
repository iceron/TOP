require_relative '../components/peg'

class Player
  @@colors_list = ["red", "green", "yellow", "blue", "violet", "light_blue"]
  def initialize breaker=true
    @breaker = breaker
  end

  def generate_secret
  end

  def breaker_input index
  end

  def maker_input secret, data, index
  end
end
