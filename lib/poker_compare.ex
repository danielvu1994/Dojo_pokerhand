defmodule PokerCompare do
  @card_high %{
    royal_flush: 11,
    straight_flush: 10,
    quads: 9,
    full_house: 8,
    flush: 7,
    straight: 6,
    triple: 5,
    two_pairs: 4,
    pair: 3,
    high_card: 2
  }
  #
  # @play_high %{
  #   rank: nil,
  #   value: 0
  # }

  @spec compare([String.t()], [String.t()]) :: String.t()
  def compare(a, a), do: "Tie."
  def compare(black, white) do
    {rank_b, no_cards_b} = player_high(black)
    {rank_w, no_cards_w} = player_high(white)
    compare(rank_b, no_cards_b, rank_w, no_cards_w)
  end

  defp compare(rank_b, _no_cards_b, rank_w, _no_cards_w) when rank_b > rank_w, do: "Black wins."
  defp compare(rank_b, _no_cards_b, rank_w, _no_cards_w) when rank_b < rank_w, do: "White wins."
  defp compare(_, no_cards_b, _, no_cards_w) do
    no_cards_b = Enum.sort(no_cards_b, &(&1 >= &2))
    no_cards_w = Enum.sort(no_cards_w, &(&1 >= &2))
    case check_high_card(no_cards_b, no_cards_w) do
      {:black, h_b} ->
        "Black wins. - with high card: #{sw_back(h_b)}"
      {:white, h_w} ->
        "White wins. - with high card: #{sw_back(h_w)}"
      _ ->
        "Tie."
    end
  end

  defp check_high_card([], []), do: {:tie, nil}
  defp check_high_card([h_b | _], [h_w | _]) when h_b > h_w, do: {:black, h_b}
  defp check_high_card([h_b | _], [h_w | _]) when h_b < h_w, do: {:white, h_w}
  defp check_high_card([_| tl_b], [_| tl_w]), do: check_high_card(tl_b, tl_w)

  @spec player_high([String.t()]) :: {integer, [integer]}
  def player_high(cards) do
    cards =
      cards
      |> Enum.map(&String.graphemes(&1))

    no_cards =
      cards
      |> Enum.map(fn [no, _type] -> sw_integer(no) end)
    type_cards = Enum.map(cards, fn [_no, type] -> type end)
    rank_high =
      cond do
        is_royal_flush?(no_cards, type_cards) ->
          @card_high.royal_flush
        is_straigh_flush?(no_cards, type_cards) ->
          @card_high.straight_flush
        is_quads?(no_cards) ->
          @card_high.quads
        is_full_house?(no_cards) ->
          @card_high.full_house
        is_flush?(type_cards) ->
          @card_high.flush
        is_straight?(no_cards) ->
          @card_high.straight
        is_triple?(no_cards) ->
          @card_high.triple
        is_two_pairs?(no_cards) ->
          @card_high.triple
        is_pair?(no_cards) ->
          @card_high.pair
        true ->
          @card_high.high_card
      end
    {rank_high, no_cards}
  end

  @spec sw_integer(String.t()) :: integer
  defp sw_integer("A"), do: 14
  defp sw_integer("K"), do: 13
  defp sw_integer("Q"), do: 12
  defp sw_integer("J"), do: 11
  defp sw_integer("T"), do: 10
  defp sw_integer(num_str) when is_bitstring(num_str) == false, do: 0
  defp sw_integer(num_str), do: String.to_integer(num_str)

  @spec sw_integer(integer) :: integer | String.t()
  defp sw_back(14), do: "Ace"
  defp sw_back(13), do: "King"
  defp sw_back(12), do: "Queen"
  defp sw_back(11), do: "Jack"
  defp sw_back(num), do: num

  @spec is_triple?([integer]) :: true | false
  def is_triple?(no_cards) do
    uniq_cards = Enum.uniq(no_cards)
    dup_cards = Enum.uniq(no_cards -- uniq_cards)
    if length(uniq_cards) == 3 and length(dup_cards) == 1, do: true, else: false
  end

  @spec is_pair?([integer]) :: true | false
  def is_pair?(no_cards) do
    uniq_cards = Enum.uniq(no_cards)
    if length(uniq_cards) == 4, do: true, else: false
  end

  @spec is_two_pairs?([integer]) :: true | false
  def is_two_pairs?(no_cards) do
    uniq_cards = Enum.uniq(no_cards)
    dup_cards = Enum.uniq(no_cards -- uniq_cards)
    if length(uniq_cards) == 3 and length(dup_cards) == 2, do: true, else: false
  end

  @spec is_straight?([integer]) :: true | false
  def is_straight?(no_cards) do
    uniq_cards = Enum.uniq(no_cards)
    is_straight?(no_cards, uniq_cards)
  end

  @spec is_straight?([integer], [integer]) :: true | false
  defp is_straight?(_, uniq_cards) when length(uniq_cards) < 5, do: false
  defp is_straight?(no_cards, _) do
    no_cards =
      no_cards
      |> Enum.sort(&(&1 >= &2))

    cond do
      # Special case: 5 4 3 2 A
      [14, 5, 4, 3, 2]== no_cards ->
        true
      (Enum.at(no_cards, 0) - Enum.at(no_cards, 4)) == 4 ->
        true
      true ->
        false
    end
  end

  @spec is_flush?([String.t()]) :: true | false
  def is_flush?(type_cards) do
    uniq_type = Enum.uniq(type_cards)
    if length(uniq_type) == 1, do: true, else: false
  end

  @spec is_full_house?([integer]) :: true | false
  def is_full_house?(no_cards)  do
    uniq_cards = Enum.uniq(no_cards)
    dup_cards = Enum.uniq(no_cards -- uniq_cards)
    if length(uniq_cards) == 2 and length(dup_cards) == 2, do: true, else: false
  end

  @spec is_quads?([integer]) :: true | false
  def is_quads?(no_cards) do
    uniq_cards = Enum.uniq(no_cards)
    dup_cards = Enum.uniq(no_cards -- uniq_cards)
    if length(uniq_cards) == 2 and length(dup_cards) == 1, do: true, else: false
  end

  @spec is_straigh_flush?([integer], [String.t()]) :: true | false
  def is_straigh_flush?(no_cards, type_cards), do: is_flush?(type_cards) and is_straight?(no_cards)

  @spec is_royal_flush?([integer], [String.t()]) :: true | false
  def is_royal_flush?(no_cards, type_cards) do
    no_cards =  Enum.sort(no_cards, &(&1 >= &2))
    is_straigh_flush?(no_cards, type_cards) and is_nut_straight?(no_cards)
  end

  @spec is_nut_straight?([integer]) :: true | false
  defp is_nut_straight?([14, 13, 12, 11, 10]), do: true
  defp is_nut_straight?(_), do: false

end
