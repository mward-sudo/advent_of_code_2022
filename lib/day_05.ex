defmodule Day05 do
  @input "lib/day_05_input.txt"

  def solve_all() do
    %{
      part1: Day05.Part1.solve(@input),
      part2: Day05.Part2.solve(@input)
    }
  end
end

defmodule Day05.Support do
  def parse_input(input) do
    # Load input from filesystem
    input_stream =
      input
      |> File.stream!()
      |> Stream.map(&String.replace(&1, "\n", ""))

    %{map: map, instructions: instructions} = split_by_blank_line(input_stream)

    parsed_map = parse_map_to_list(map)

    parsed_instructions = parse_instructions(instructions)

    %{map: parsed_map, instructions: parsed_instructions}
  end

  def split_by_blank_line(input_stream) do
    [map, _, instructions] =
      input_stream
      |> Stream.chunk_by(fn line -> line == "" end)
      |> Enum.to_list()

    %{map: map, instructions: instructions}
  end

  def parse_map_to_list(map) do
    map
    |> Enum.reverse()
    |> Enum.drop(1)
    # Map over the list, and split each string every 4th character
    |> Enum.map(fn line ->
      line
      |> String.codepoints()
      |> Enum.chunk_every(4)
      |> Enum.map(&Enum.join(&1, ""))
    end)
    |> Enum.zip_with(& &1)
    |> Enum.map(fn line ->
      line
      |> Enum.map(fn str ->
        str
        |> String.trim()
        |> String.replace("[", "")
        |> String.replace("]", "")
      end)
      |> Enum.filter(&(&1 != ""))
      |> Enum.reverse()
    end)
    |> Enum.with_index()
  end

  def parse_instructions(instructions) do
    Enum.map(instructions, fn instruction ->
      [_, amount, _, from, _, to] =
        instruction
        |> String.split(" ")

      %{
        amount: String.to_integer(amount),
        from_stack_no: String.to_integer(from) - 1,
        to_stack_no: String.to_integer(to) - 1
      }
    end)
  end

  def top_crates(list) do
    # use Enum.map to apply a function to each stack in the list
    crates = Enum.map(list, fn {[head | _], _} -> head end)
    # use Enum.join to join the crates into a single string
    Enum.join(crates)
  end

  def transpose(lists) do
    lists
    |> Enum.map(&Enum.with_index/1)
    |> Enum.reduce([], fn list, acc ->
      Enum.zip(list, acc) |> Enum.map(fn {value, sublist} -> [value | sublist] end)
    end)
  end
end

defmodule Day05.Part1 do
  import Day05.Support

  def solve(input) do
    %{map: map, instructions: instructions} = parse_input(input)

    move_all_elements(map, instructions)
    |> top_crates()
  end

  def move_all_elements(list, [instruction | instructions]) do
    move_elements(list, instruction)
    |> move_all_elements(instructions)
  end

  def move_all_elements(list, []) do
    list
  end

  def move_elements(list, %{
        amount: amount,
        from_stack_no: from_stack_no,
        to_stack_no: to_stack_no
      }) do
    # Get the stacks from the list
    {from_crates, _} = Enum.at(list, from_stack_no)
    {to_crates, _} = Enum.at(list, to_stack_no)

    new_to_crates =
      (Enum.take(from_crates, amount) |> Enum.reverse()) ++
        to_crates

    new_from_crates = Enum.drop(from_crates, amount)

    # Replace the stacks in the list
    List.replace_at(list, from_stack_no, {new_from_crates, from_stack_no})
    |> List.replace_at(to_stack_no, {new_to_crates, to_stack_no})
  end
end

defmodule Day05.Part2 do
  import Day05.Support

  def solve(input) do
    %{map: map, instructions: instructions} = parse_input(input)

    move_all_elements(map, instructions)
    |> top_crates()
  end

  def move_all_elements(list, [instruction | instructions]) do
    move_elements(list, instruction)
    |> move_all_elements(instructions)
  end

  def move_all_elements(list, []) do
    list
  end

  def move_elements(list, %{
        amount: amount,
        from_stack_no: from_stack_no,
        to_stack_no: to_stack_no
      }) do
    # Get the stacks from the list
    {from_crates, _} = Enum.at(list, from_stack_no)
    {to_crates, _} = Enum.at(list, to_stack_no)

    new_to_crates = Enum.take(from_crates, amount) ++ to_crates
    new_from_crates = Enum.drop(from_crates, amount)

    # Replace the stacks in the list
    List.replace_at(list, from_stack_no, {new_from_crates, from_stack_no})
    |> List.replace_at(to_stack_no, {new_to_crates, to_stack_no})
  end
end
