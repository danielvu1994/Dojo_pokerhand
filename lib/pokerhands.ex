defmodule Pokerhands do
  require PokerCompare
  @moduledoc """
  Documentation for `Pokerhands`.
  """
  def cal_result(black, white) do
    black = convert_to_list_card(black)
    white = convert_to_list_card(white)

    {valid, reason} = is_card_valid?(black ,white)
    if valid == :error do
      {valid, reason}
    else    # :ok
      PokerCompare.compare(black, white)
    end
  end

  defp convert_to_list_card(cards) do
    cards
    |> String.split([" "], trim: true)
    |> Enum.map(&String.upcase(&1))
  end

  # Check valid cards
  defp is_card_valid?(black, white) do
    {valid_b, reason_b} = player_cards_valid?(black)
    {valid_w, reason_w} = player_cards_valid?(white)

    case {valid_b, valid_w} do
      {:ok, :ok} ->
        {:ok, "All are good"}
      {:error, :error} ->
        {:error, "Black: #{reason_b}, White: #{reason_w}"}
      {:error, :ok} ->
        {:error, "Black: #{reason_b}"}
      {:ok, :error} ->
        {:error, "White: #{reason_w}"}
    end
  end

  defp player_cards_valid?(cards) do
    num_of_cards = length(cards)

    valid_cards =
      cards
      |> Enum.filter(&String.match?(&1,  ~r{^[0-9TJQKA][HDCS]}) == true)
      # |> IO.inspect
      |> length

    player_cards_valid?(num_of_cards, valid_cards)
  end

  defp player_cards_valid?(5, 5), do: {:ok, "Cards are good"}
  defp player_cards_valid?(num, valid) when num < 5 and valid < num,
  do: {:error, "Cards are not enough! - Invalid cards!!"}
  defp player_cards_valid?(num, _valid) when num < 5,
  do: {:error, "Cards are not enough!"}
  defp player_cards_valid?(5, valid) when valid < 5,
  do: {:error, "Invalid cards!!"}
end
