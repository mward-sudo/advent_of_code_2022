defmodule Day01 do
  @input "./lib/day_01_input.txt"

  def solve_all() do
    %{
      part1: Day01.Part1.solve(@input),
      part2: Day01.Part2.solve(@input)
    }
  end
end

defmodule Day01.Support do
  def open_file(input_file) do
    File.read!(input_file)
    |> split_by_blank_lines()
    |> Stream.map(&split_by_newline/1)
    |> Stream.map(&reduce_to_sum/1)
    |> Enum.sort(:desc)
  end

  def split_by_blank_lines(input) do
    # Split the input by blank lines
    String.split(input, "\n\n")
  end

  def split_by_newline(input) do
    # Split the input by newlines
    String.split(input, "\n")
  end

  defp reduce_to_sum(input) do
    # Reduce the input to a sum, using pattern matching to guard against blank strings
    Enum.reduce(input, 0, fn
      "", acc -> acc
      x, acc -> acc + String.to_integer(x)
    end)
  end
end

defmodule Day01.Part1 do
  import Day01.Support

  def solve(input_file) do
    open_file(input_file)
    |> Enum.at(0)
  end
end

defmodule Day01.Part2 do
  import Day01.Support

  def solve(input_file) do
    open_file(input_file)
    # Sum of 0..2
    |> Enum.slice(0..2)
    |> Enum.sum()
  end
end
