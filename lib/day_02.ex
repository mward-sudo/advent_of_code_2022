defmodule Day02 do
  @input "./lib/day_02_input.txt"

  def solve_all() do
    %{
      part1: Day02.Part01.solve(@input),
      part2: Day02.Part02.solve(@input)
    }
  end
end

defmodule Day02.Support do
  @rock %{
    hand: :rock,
    score: 1,
    beats: nil,
    beaten_by: nil
  }
  @paper %{
    hand: :paper,
    score: 2,
    beats: nil,
    beaten_by: nil
  }
  @scissors %{
    hand: :scissors,
    score: 3,
    beats: nil,
    beaten_by: nil
  }
  @win_score 6
  @tie_score 3
  @loss_score 0

  def win_score, do: @win_score
  def tie_score, do: @tie_score
  def loss_score, do: @loss_score

  def rock, do: %{@rock | beats: @scissors, beaten_by: @paper}
  def paper, do: %{@paper | beats: @rock, beaten_by: @scissors}
  def scissors, do: %{@scissors | beats: @paper, beaten_by: @rock}

  def player_one_codes,
    do: %{
      "A" => rock(),
      "B" => paper(),
      "C" => scissors()
    }

  def parse_input_file(input) do
    input
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  def get_score_for_player_two(hands) do
    hands
    # Reduce the list to a sum of {_, [_, player_two_score]}
    |> Enum.reduce(0, fn {_winner, [_player_one_score, player_two_score]}, player_two_score_acc ->
      player_two_score_acc + player_two_score
    end)
  end

  def parse_player_one_hand(hand), do: player_one_codes()[hand]
end

defmodule Day02.Part01 do
  import Day02.Support

  @player_two_codes %{
    "X" => rock(),
    "Y" => paper(),
    "Z" => scissors()
  }

  def solve(input) do
    input
    |> parse_input_file()
    |> Enum.map(&parse_hands(&1))
    |> Enum.map(&get_score_for_hands(&1))
    |> get_score_for_player_two()
  end

  defp parse_hands([player1, player2]) do
    [parse_player_one_hand(player1), parse_player_two_hand(player2)]
  end

  def parse_player_two_hand(hand), do: @player_two_codes[hand]

  defp get_score_for_hands([player_one_hand, player_two_hand]) do
    cond do
      player_one_hand == player_two_hand ->
        {
          :tie,
          [
            tie_score() + player_one_hand.score,
            tie_score() + player_two_hand.score
          ]
        }

      player_one_hand.beats.hand == player_two_hand.hand ->
        {
          :player_one,
          [
            win_score() + player_one_hand.score,
            loss_score() + player_two_hand.score
          ]
        }

      player_one_hand.beaten_by.hand == player_two_hand.hand ->
        {
          :player_two,
          [
            loss_score() + player_one_hand.score,
            win_score() + player_two_hand.score
          ]
        }
    end
  end
end

defmodule Day02.Part02 do
  import Day02.Support

  @player_two_codes %{
    "X" => :loss,
    "Y" => :tie,
    "Z" => :win
  }

  def solve(input) do
    input
    |> parse_input_file()
    |> Enum.map(&parse_hands(&1))
    |> Enum.map(&get_score_for_hands(&1))
    |> get_score_for_player_two()
  end

  defp parse_hands([player1, player2]) do
    [parse_player_one_hand(player1), parse_player_two_hand(player2)]
  end

  defp parse_player_two_hand(hand), do: @player_two_codes[hand]

  defp get_score_for_hands([player_one_hand, :win]) do
    player_two_hand = player_one_hand.beaten_by

    {
      :player_two,
      [
        loss_score() + player_one_hand.score,
        win_score() + player_two_hand.score
      ]
    }
  end

  defp get_score_for_hands([player_one_hand, :tie]) do
    player_two_hand = player_one_hand

    {
      :tie,
      [
        tie_score() + player_one_hand.score,
        tie_score() + player_two_hand.score
      ]
    }
  end

  defp get_score_for_hands([player_one_hand, :loss]) do
    player_two_hand = player_one_hand.beats

    {
      :player_one,
      [
        win_score() + player_one_hand.score,
        loss_score() + player_two_hand.score
      ]
    }
  end
end
