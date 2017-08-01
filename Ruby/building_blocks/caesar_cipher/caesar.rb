def caesar_cipher(plaintext, shift)
   letters_downcase = ('a'..'z').to_a
   letters_upcase = ('A'..'Z').to_a
   ret = String.new
   plaintext.chars.each do |x|
      if letters_downcase.include?(x)
         ret.concat(letters_downcase[letters_downcase.find_index(x.downcase) + shift - letters_downcase.size].downcase)
      elsif letters_upcase.include?(x)
         ret.concat(letters_upcase[letters_upcase.find_index(x.upcase) + shift - letters_upcase.size].upcase)
      else
         ret.concat(x)
      end			
   end
   return ret
end


puts caesar_cipher('abc',3)
puts caesar_cipher('abC',3)
puts caesar_cipher('The quick brown fox jumps over the lazy dog',5)
puts caesar_cipher('My name is 007',9)