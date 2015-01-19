class Array
  def my_uniq
    my_uniq = []
    self.each do |el|
      my_uniq << el unless my_uniq.include?(el)
    end
    my_uniq
  end

  def two_sum
    pairs = []
    self.size.times do |i|
      (i + 1...self.size).each do |j|
        pairs << [i,j] if (self[i] + self[j]).zero?
      end
    end
    pairs
  end
end

class Towers

  def self.make_piles
    [[1, 2, 3], [], []]
  end

  attr_reader :piles

  def initialize
    @piles = Towers.make_piles
  end

  def move(start, destination)
    disc = piles[start].shift
    raise "invalid move" if !piles[destination].empty? && piles[destination].first < disc
    piles[destination].unshift(disc)
  end

  def won?
    piles[2].count == 3
  end

end

def my_transpose(array)
  result = Array.new(array.length) { Array.new(array.length) }
  result.each_index do |i|
    result[i].each_index do |j|
      result[i][j] = array[j][i]
    end
  end
  result
end

def stock_picker(prices)
  result = []
  best_profit = 0

  prices.each_index do |buy_date|
    prices.each_index do |sell_date|
      next if sell_date <= buy_date
      profit = prices[sell_date] - prices[buy_date]
      if profit > best_profit
        best_profit = profit
        result = [buy_date, sell_date]
      end
    end
  end

  result
end
