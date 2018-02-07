defmodule GuessingGame do
  def begin(prompt \\ "Oh hi there!") do
    IO.puts prompt
    reply = IO.gets("Do you wanna play a game?\n") |> String.trim
    cond do
      Enum.find(~w(y Y yes Yes sure Sure ok Ok), &(&1 == reply)) -> start_game()
      Enum.find(~w(n N no No nope Nope), &(&1 == reply)) -> "Ok, maybe later then."
      true -> begin "I'm not sure what you mean by #{reply}..."
    end
  end

  def start_game do
    IO.puts "Let's play! Pick two numbers to guess between, " <>
            "then pick a number in that range and I'll guess it."
    a = get_number("What's your first number?\n")
    b = get_number("Ok, what's your second number?\n")
    IO.gets "Ok now pick a number between #{a} and #{b} and press 'Enter' when you got it."
    play(a, b)
  end

  def play(a, b, n \\ 1)
  def play(a, b, n) when a > b, do: play(b, a, n)
  def play(a, b, n) do
    guess = make_guess(a,b)
    case check_guess(guess) do
      1             -> play(guess+1,b,n+1)
      -1            -> play(a,guess-1,n+1)
      0 when n == 1 -> IO.puts "Wow!!!! I got it on my first try. Thanks for playing."
      0             -> IO.puts "Awesome! It only took me #{n} tries. Thanks for playing."
    end
  end

  def make_guess(a, b) do
    # IO.puts "Debug: a: #{a}, b: #{b}"
    Enum.random(a..b)
  end

  def check_guess(guess) do
    reply = IO.gets("Hmm... is it #{guess}?\n") |> String.trim
    cond do
      Enum.find(~w(bigger larger higher), &(&1 == reply)) -> 1
      Enum.find(~w(smaller lower), &(&1 == reply)) -> -1
      Enum.find(~w(y Y yes Yes yep), &(&1 == reply)) -> 0
      true -> IO.puts "I'm not sure what you mean by #{reply}. Is your number bigger or smaller?"
              check_guess(guess)
    end
  end

  defp get_number(prompt) do
    case IO.gets(prompt) |> Integer.parse do
      {n, _} -> n
      _      -> get_number("I couldn't parse that as a number. Try again.\n")
    end
  end
end
