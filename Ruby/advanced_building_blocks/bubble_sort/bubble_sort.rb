def bubble_sort(arr)
  swapped = true
  until !swapped do
    swapped = false
    arr.each_with_index do |e, i|
      if i < arr.length-1
        if e > arr[i+1]
          arr[i], arr[i+1] = arr[i+1], arr[i]
          swapped = true
        end
      end
    end
  end
  p arr
end


bubble_sort([4,3,78,2,0,2])


def bubble_sort_by(arr, &block)
  swapped = true
  until !swapped do
    swapped = false
    arr.each_with_index do |e, i|
      if i < arr.length-1
        if block.call(arr[i], arr[i+1]) > 0
          arr[i], arr[i+1] = arr[i+1], arr[i]
          swapped = true
        end
      end
    end
  end
  p arr
end


bubble_sort_by(["hi","hello","hey"]) do |left,right|
  left.length - right.length
end
