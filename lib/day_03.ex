defmodule Day03 do
  @input_file "./lib/day_03_input.txt"

  def solve_all() do
    %{
      part1: Day03.Part1.solve(@input_file),
      part2: Day03.Part2.solve(@input_file)
    }
  end
end

defmodule Day03.Support do
  def open_file_stream(input) do
    # Read the input file, creating a stream of lines
    input
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def character_priority(character) when is_binary(character) do
    # Check if the character is a valid input, function guard guarantees that
    # the input is a binary
    with {:ok} <- is_valid_input_length(character),
         {:ok} <- is_valid_input_character(character) do
      # If the input is valid, return the priority
      priorirty =
        case character do
          <<c::utf8>> when c in ?a..?z -> c - 96
          <<c::utf8>> when c in ?A..?Z -> c - 38
        end

      {:ok, character, priorirty}
    else
      {:error, message} -> {:error, message}
    end
  end

  defp is_valid_input_length(character) do
    case byte_size(character) do
      1 -> {:ok}
      _ -> {:error, "Input must be length 1"}
    end
  end

  defp is_valid_input_character(character) do
    case character do
      <<c::utf8>> when c in ?a..?z -> {:ok}
      <<c::utf8>> when c in ?A..?Z -> {:ok}
      _ -> {:error, "Input must be an alpha character"}
    end
  end
end

defmodule Day03.Part1 do
  import Day03.Support

  def solve(input) when is_binary(input) do
    input
    |> open_file_stream()
    # Get a list containing the first and second halves of the binary
    |> Stream.map(&split_binary_into_compartments/1)
    # Each element is a list of two binaries. Find the common character in each
    # binary, and return a list of the common characters
    |> Stream.map(&find_common_character_in_list_of_two_strings/1)
    # Create a list of the priorities of each common character
    |> Stream.map(&character_priority/1)
    # Map the list to a list of the priorities
    |> Stream.map(fn {:ok, _, priority} -> priority end)
    # Sum the priorities
    |> Enum.sum()
  end

  defp split_binary_into_compartments(binary) do
    # Split the binary into two halves
    binary
    |> String.split_at(div(String.length(binary), 2))
  end

  defp find_common_character_in_list_of_two_strings({first_half, second_half}) do
    # Create a list of the characters in the first half
    first_half
    |> String.graphemes()
    |> Enum.filter(fn x -> x in (second_half |> String.graphemes()) end)
    # Return the first common character
    |> List.first()
  end
end

defmodule Day03.Part2 do
  import Day03.Support

  def solve(input) do
    input
    |> open_file_stream()
    |> Stream.chunk_every(3)
    |> Stream.map(fn chunk -> find_common_character_in_list_of_strings(chunk) end)
    |> Stream.map(fn x ->
      {:ok, _, priority} = character_priority(x)
      priority
    end)
    |> Enum.sum()
  end

  # Recursive function to take a list of strings, and return the common characters
  # across all of the strings
  defp find_common_character_in_list_of_strings([head | []]) do
    # There is only one string, no comparison can be done
    head
  end

  defp find_common_character_in_list_of_strings([head | tail]) do
    # Recursively call the function with the tail of the list
    common_chars =
      find_common_character_in_list_of_strings(tail)
      |> String.graphemes()

    head
    |> String.graphemes()
    # Create a list of the common characters between the two lists
    |> Stream.filter(fn x -> x in common_chars end)
    |> Stream.dedup()
    |> Enum.join()
  end
end

# Day03.Part1.solve("input/input.txt") == 7701
# Day03.Part2.solve("input/input.txt") == 2644
