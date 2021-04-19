defmodule PokerCompareTest do
  use ExUnit.Case
  # doctest Pokerhands

  @tag :compare
  test "Is a pair" do
    assert PokerCompare.is_pair?([2, 3, 5, 9, 2])
  end

  @tag :compare
  test "Not a pair" do
    refute PokerCompare.is_pair?([2, 3, 5, 9, 4])
  end

  @tag :compare
  test "Is two pair" do
    assert PokerCompare.is_two_pairs?([2, 3, 3, 9, 2])
  end

  @tag :compare
  test "Not two pair" do
    refute PokerCompare.is_two_pairs?([2, 3, 2, 9, 2])
  end

  @tag :compare
  test "Is triple" do
    assert PokerCompare.is_triple?([2, 2, 3, 9,2])
  end

  @tag :compare
  test "Not triple, two pairs" do
    refute PokerCompare.is_triple?([2, 3, 3, 2, 4])
  end

  @tag :compare
  test "Is straight 10 J Q K A" do
    assert PokerCompare.is_straight?([10, 14, 13, 11, 12])
  end

  @tag :compare
  test "Is straight A 2 3 4 5" do
    assert PokerCompare.is_straight?([3, 14, 2, 5, 4])
  end

  @tag :compare
  test "Not straight, two pairs" do
    refute PokerCompare.is_straight?([2, 3, 3, 2, 4])
  end

  @tag :compare
  test "Is Flush" do
    assert PokerCompare.is_flush?(["C", "C", "C", "C", "C"])
  end

  @tag :compare
  test "Not flush" do
    refute PokerCompare.is_flush?(["D", "C", "C", "C", "C"])
  end

  @tag :compare
  test "Is Full House" do
    assert PokerCompare.is_full_house?([2,2,2,3,3])
  end

  @tag :compare
  test "Not Full House" do
    refute PokerCompare.is_full_house?([2,2,2,2,3])
  end

  @tag :compare
  test "Is 4 of a kind" do
    assert PokerCompare.is_quads?([2,2,2,2,3])
  end

  @tag :compare
  test "Not 4 of a kind" do
    refute PokerCompare.is_quads?([2,2,2,3,3])
  end

  @tag :compare
  test "Is Straight Flush" do
    assert PokerCompare.is_straigh_flush?([14,2,3,4,5], ["D", "D", "D", "D", "D"])
  end

  @tag :compare
  test "Not Straight Flush, just straight" do
    refute PokerCompare.is_straigh_flush?([14,2,3,4,5], ["D", "D", "D", "H", "D"])
  end

  @tag :compare
  test "Not Straight Flush, just flush" do
    refute PokerCompare.is_straigh_flush?([14,2,3,4,6], ["D", "D", "D", "D", "D"])
  end

  @tag :compare
  test "Royal flush" do
    assert PokerCompare.is_royal_flush?([14, 10, 11, 12, 13], ["D", "D", "D", "D", "D"])
  end

  @tag :compare
  test "Not royal_flush, just straight flush" do
    refute PokerCompare.is_royal_flush?([14,2,3,4,5], ["D", "D", "D", "D", "D"])
  end

  @tag :compare
  test "Triple hand" do
    assert { :triple, _list} = PokerCompare.player_high(["5D", "5H", "5C", "2D", "4S"])
  end

  @tag :compare
  test "straight hand" do
    assert { :straight, _list} = PokerCompare.player_high(["2D", "6H", "3C", "4D", "5S"])
  end

  @tag :compare
  test "White win with High Card Ace" do
    assert PokerCompare.compare(["2H", "3D", "5S", "9C", "KD"], ["2C", "3H", "4S", "8C", "AH"]) ==
      "White wins. With High card but higher card: Ace"
  end

  @tag :compare
  test "Black win with High Card 9" do
    assert PokerCompare.compare(["2H", "3D", "5S", "9C", "KD"], ["2C", "3H", "4S", "8C", "KH"]) ==
      "Black wins. With High card but higher card: 9"
  end

  @tag :compare
  test "White win with High Card Jack" do
    assert PokerCompare.compare(["2H", "3H", "5H", "9H", "8H"], ["4H", "7H", "TH", "JH", "6H"]) ==
      "White wins. With Flush but higher card: Jack"
  end

  @tag :compare
  test "White win with Royal Flush" do
    assert PokerCompare.compare(["6H", "7H", "5H", "9H", "8H"], ["TH", "JH", "KH", "QH", "AH"]) ==
      "White wins. With Royal Flush"
  end

  # @tag :compare
  test "Black win with 3 of a kind" do
    assert PokerCompare.compare(["6H", "6C", "6D", "9H", "8H"], ["TH", "TC", "9H", "9S", "AH"]) ==
      "Black wins. With 3 of a kind"
  end

  # @tag :compare
  test "Black win with 3 of a kind and higher card" do
    assert PokerCompare.compare(["6H", "6C", "6D", "9H", "8H"], ["6H", "6C", "6D", "9S", "7H"]) ==
      "Black wins. With 3 of a kind but higher card: 8"
  end


end
