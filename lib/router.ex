defmodule Router do
  def route(tweet) do
    {:ok, pid} = Worker.start_link([])
    Worker.handle(pid, tweet)
  end
end
