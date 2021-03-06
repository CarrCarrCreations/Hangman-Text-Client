defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, State, Summary}

  # won, lost, :good_guess, :bad_guess, :used, :initializing
  def play(game = %State{tally: %{game_state: :won}}) do
    exit_with_message("You Won!!!", Enum.join(game.game_service.letters, ""))
  end

  def play(game = %State{tally: %{game_state: :lost}}) do
    exit_with_message("Sorry, you Lost...", Enum.join(game.game_service.letters, ""))
  end

  def play(game = %State{tally: %{game_state: :good_guess}}) do
    continue_with_message(game, "Good guess!")
  end

  def play(game = %State{tally: %{game_state: :bad_guess}}) do
    continue_with_message(game, "Sorry, that isn't in the word.")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "You've already used this letter")
  end

  def play(game) do
    continue(game)
  end

  def display(game), do: game
  def prompt(game), do: game
  def make_move(game), do: game

  def continue(game) do
    game
    |> Summary.display()
    |> Prompter.accept_move()
    |> Mover.make_move()
    |> play()
  end

  defp continue_with_message(game, msg) do
    IO.puts(msg)
    continue(game)
  end

  defp exit_with_message(msg, word) do
    IO.puts(msg)
    IO.puts("The word is #{word}")
    exit(:normal)
  end
end
