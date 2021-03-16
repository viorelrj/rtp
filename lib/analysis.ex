defmodule RTP.Analysis do
  def get_score(message) do
    words = String.split(message, ~r/[\s.!?:;]{1,}/, trim: true)
    count = Enum.count(words)

    case count do
      0 -> 0
      _wildcard -> (Enum.map(words, &RTP.Sentiments.get(&1)) |> Enum.sum()) / count
    end
  end
end
