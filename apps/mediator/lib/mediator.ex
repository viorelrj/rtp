defmodule Mediator do
  def encode_topic(topic, content) do
    Poison.encode!(%{
      type: "send",
      topic: topic,
      content: content
    })
  end

  def decode_topic(content) do
    content = Poison.decode! content
    {content["topic"], content["content"]}
  end

end
