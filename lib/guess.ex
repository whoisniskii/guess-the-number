defmodule Guess do
  use Application

  def start(_,_) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts("Let's play Guess the Number")

    IO.gets("Pick a difficult level (1, 2, 3, 4 or 5): ")
    |> parse_input()
    |> pickup_number()
    |> play()
  end

  def play(picked_num) do
    IO.gets("I have my number, what is your guess?: ")
    |> parse_input()
    |> guess(picked_num, 1)
  end

  def guess(usr_guess, picked_num, count) when usr_guess > picked_num do
    IO.gets("Too high, Guess again: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(usr_guess, picked_num, count) when usr_guess < picked_num do
    IO.gets("Too low, Guess again: ")
    |> parse_input()
    |> guess(picked_num, count + 1)
  end

  def guess(_usr_guess, _picked_num, count) do
    IO.puts("You got it! #{count} guess")
    show_score(count)
  end

  def show_score(guesses) when guesses > 6 do
    IO.puts("Better luck next time")
  end

  def show_score(guesses) do
    {_, msg} = %{1..1 => "You're a mind rider!",
      2..4 => "Most impresive",
      3..6 => "You can do better than that"}
      |> Enum.find(fn {range, _} ->
        Enum.member?(range, guesses)
      end)
      IO.puts(msg)
  end

  def parse_input(:error) do
    IO.puts("Invalid input.")
    run()
  end

  def parse_input({num, _}), do: num

  def parse_input(data) do
    data
    |> Integer.parse()
    |> parse_input()
  end

  def get_range(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      4 -> 1..10000
      5 -> 1..100000
      _ -> IO.puts("Invalid level.")
      run()
    end
  end

  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end
end
