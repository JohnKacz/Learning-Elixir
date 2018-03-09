defmodule DnB.Game.Board do
  alias __MODULE__

  defstruct open_lines: MapSet.new(),
            open_boxes: MapSet.new(),
            player1_lines: MapSet.new(),
            player1_boxes: MapSet.new(),
            player2_lines: MapSet.new(),
            player2_boxes: MapSet.new(),
            grid_size: 0

  @h_open "    "
  @h_line "----"
  @vertex "+"

  def new_board(size) do
    %Board{open_lines: lines(size), open_boxes: boxes(size), grid_size: size}
  end

  def print(board = %{grid_size: size}) do
    for row <- 0..(size - 1) do
      print_h(board, row, size)
      print_v(board, row, size)
    end

    print_h(board, size, size)
  end

  ###########################################################################################

  defp lines(size) do
    lines =
      for x <- 0..size,
          y <- 0..size,
          x + y != size * 2 do
        cond do
          x == size -> {x, y, :y}
          y == size -> {x, y, :x}
          true -> [{x, y, :x}, {x, y, :y}]
        end
      end

    lines |> List.flatten() |> MapSet.new()
  end

  defp boxes(size) do
    for x <- 0..(size - 1),
        y <- 0..(size - 1),
        into: MapSet.new(),
        do: {x, y}
  end

  defp print_h(%{open_lines: lines}, row, size) do
    for col <- 0..(size - 1) do
      if MapSet.member?(lines, {col, row, :x}),
        do: IO.write("#{@vertex}#{@h_open}"),
        else: IO.write("#{@vertex}#{@h_line}")
    end

    IO.write("#{@vertex}\n")
  end

  defp print_v(%{open_lines: lines, player1_boxes: p1b, player2_boxes: p2b}, row, size) do
    for col <- 0..(size - 1) do
      case {MapSet.member?(lines, {col, row, :y}), MapSet.member?(p1b, {col, row}),
            MapSet.member?(p2b, {col, row})} do
        {false, true, false} -> IO.write("| P1 ")
        {false, false, true} -> IO.write("| P2 ")
        {false, false, false} -> IO.write("|#{@h_open}")
        {true, _, _} -> IO.write(" #{@h_open}")
      end
    end

    if MapSet.member?(lines, {size, row, :y}), do: IO.write("\n"), else: IO.write("|\n")
  end
end
