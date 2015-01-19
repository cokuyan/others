require 'rspec'
require 'arrays.rb'

describe "#my_uniq" do

  subject(:array) {[1,2,3,3]}

  it "should remove duplicates" do
    expect([1, 2, 1, 3, 3].my_uniq).to eq([1,2,3])
  end

  it "should leave an array with no duplicates alone" do
    expect([1,2,3].my_uniq).to eq([1,2,3])
  end

  it "should not affect the original array" do
    array.my_uniq
    expect(array).to eq([1,2,3,3])
  end
end

describe "#two_sum" do

  subject(:array) {[-1, 0, 2, -2, 1]}
  let(:no_pairs) {[1,2,3,4]}

  it "should contain pairs of indices where elements sum to zero" do
      expect(array.two_sum).to include([0,4]).and include ([2,3])
  end

  it "should be sorted" do
    expect(array.two_sum).to eq(array.two_sum.sort)
  end

  it "should return an empty array if no pairs are found" do
    expect(no_pairs.two_sum).to eq([])
  end

  it "should only contain valid pairs" do
    expect(array.two_sum).to eq([[0, 4], [2, 3]])
  end
end

describe Towers do

  subject(:towers) {Towers.new}

  it "initializes all discs to the first pile" do
    expect(towers.piles[0]).to eq([1,2,3])
  end

  it "initializes three piles" do
    expect(towers.piles.count).to eq(3)
  end

  it "initializes two empty piles" do
    count1 = towers.piles[1].count
    count2 = towers.piles[2].count
    expect(count1 + count2).to be_zero
  end

  describe "#move" do
    it "should move an element from one tower to another" do
      towers.move(0,1)
      expect(towers.piles[1]).to_not be_empty
    end

    it "should leave the start pile with one fewer item" do
      count = towers.piles[0].count
      towers.move(0,1)
      expect(towers.piles[0].count).to eq(count - 1)
    end

    it "should raise an error upon invalid move" do
      expect {2.times {towers.move(0,1)}}.to raise_error("invalid move")
    end
  end

  describe "#won?" do
    it "should return false if not won" do
      expect(towers.won?).to be false
    end

    it "returns true if won" do
      towers.piles[0], towers.piles[2] = towers.piles[2], towers.piles[0]
      expect(towers.won?).to be true
    end
  end
end

describe "#my_transpose" do
  subject(:array) do [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ]
  end

  let(:result) do [[0, 3, 6],
    [1, 4, 7],
    [2, 5, 8]]
  end

  it "transposes an array" do
    expect(my_transpose(array)).to eq(result)
  end

  it "does not modify the array" do
    copy = array.map { |subarray| subarray.dup }
    my_transpose(array)
    expect(copy).to eq(array)
  end

end

describe "#stock_picker" do
  subject(:prices) { [5, 4, 3, 1, 9, 7, 11] }
  let(:no_profit) { [5, 4, 3, 2, 1] }

  it "picks the most profitable buy and sell days" do
    expect(stock_picker(prices)).to eq([3, 6])
  end

  it "returns empty array if no profit to be made" do
    expect(stock_picker(no_profit)).to be_empty
  end

end
