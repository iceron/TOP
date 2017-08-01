def stock_picker(prices)
   result = Array.new
   max = 0
   i = 0
   while i < prices.length
      buy_price = prices[i]
      j = i
      while j < prices.length
         sell_price = prices[j]
         profit = sell_price - buy_price
         if max == 0 || max < profit
            max = profit
            result.clear
            result << i << j
         end
         j = j + 1
      end
      i = i + 1
   end
   return result
end

p stock_picker([17,3,6,9,15,8,6,1,10])
