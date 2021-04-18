defmodule PokerhandsTest do
  use ExUnit.Case
  # doctest Pokerhands

  @tag :pending
  test "Lack of a card" do
    assert {:error, "Black: Cards are not enough!"}  =
      Pokerhands.cal_result("2H 3D 5S 9C", "2C 3H 4S 8C AH")
  end

  @tag :pending
  test "Invalid input" do
    assert {:error, "White: Invalid cards!!"}  =
      Pokerhands.cal_result("2H 3D 5S 9C KD", "2C 3H 4S 8C Ap")
  end

  @tag :pending
  test "Both players's inputs are wrong" do
    assert {:error, "Black: Cards are not enough!, White: Invalid cards!!"}  =
      Pokerhands.cal_result("2H 3D 5S 9C", "2C 3H 4S 8C Ap")
  end

  @tag :pending
  test "Complicated error" do
    assert {:error, "Black: Cards are not enough! - Invalid cards!!, White: Cards are not enough! - Invalid cards!!"}  =
      Pokerhands.cal_result("2H 3D 5S 9p", "2C 3H 8C Ap")
  end

  @tag :pending
  test "White win with High Card" do
    assert Pokerhands.cal_result("2H 3D 5S 9C KD", "2C 3H 4S 8C AH") ==
      {:ok, "White wins. - with high card: Ace"}
  end

  @tag :pending
  test "Black  hite win with full house" do
    assert Pokerhands.cal_result("2H 4S 4C 2D 4H", "2S 8S AS QS 3S") ==
      {:ok, "Black wins. - with full house: 4 over 2"}
  end

  @tag :pending
  test "Black win with high card" do
    assert Pokerhands.cal_result("2H 3D 5S 9C KD", "2C 3H 4S 8C KH") ==
      {:ok, "Black wins. - with high card: 9"}
  end

  @tag :pending
  test "Tie." do
    assert Pokerhands.cal_result("2H 3D 5S 9C KD", "2D 3H 5C 9S KH") ==
      {:ok, "Tie."}
  end
end
