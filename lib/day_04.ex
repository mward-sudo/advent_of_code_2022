defmodule Day04 do
  @input "./lib/day_04_input.txt"

  def solve_all() do
    %{
      part1: Day04.Part1.solve(@input),
      part2: Day04.Part2.solve(@input)
    }
  end
end

defmodule Day04.Support do
  def open_file_stream(input) do
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def parse_pairs(pair) do
    [one, two] =
      String.split(pair, ",")
      |> Enum.map(&convert_string_to_range_list/1)

    {one, two}
  end

  def convert_string_to_range_list(range_string) do
    [min, max] = String.split(range_string, "-")

    # convert the range min..max to a list
    String.to_integer(min)..String.to_integer(max)
  end
end

defmodule Day04.Part1 do
  import Day04.Support

  def solve(input) do
    input
    |> open_file_stream()
    |> Stream.map(&parse_pairs/1)
    |> count_wholly_overlapping_pairs()
  end

  defp count_wholly_overlapping_pairs(pairs) do
    pairs
    |> Stream.filter(&pair_wholly_overlaps?/1)
    |> Enum.count()
  end

  defp pair_wholly_overlaps?({one, two}) do
    Enum.all?(one, &(&1 in two)) or Enum.all?(two, &(&1 in one))
  end
end

defmodule Day04.Part2 do
  import Day04.Support

  def solve(input) do
    input
    |> open_file_stream()
    |> Stream.map(&parse_pairs/1)
    |> count_partially_overlapping_pairs()
  end

  defp count_partially_overlapping_pairs(pairs) do
    pairs
    |> Stream.filter(&pair_partially_overlaps?/1)
    |> Enum.count()
  end

  defp pair_partially_overlaps?({one, two}) do
    Enum.any?(one, &(&1 in two))
  end
end
