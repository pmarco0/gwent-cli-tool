defmodule Gwent.CLI do

  def main(argv \\ []) do
    OptionParser.parse(argv,switches: [card: :string])
      |> elem(0)
      |> Keyword.get(:card)
      |> get_info
  end

  defp get_json_colors(filename) do
    with  {:ok, body} <- File.read(filename),
          {:ok, json} <- Poison.decode(body), do: for {key,val} <- json, into: %{}, do: {key, String.to_atom(val)}
  end

  defp get_info(card_name) do
    vars = %{card_url: "https://api.gwentapi.com/v0/cards"}

    colors = get_json_colors("colors.json")

    results = HTTPotion.get(vars[:card_url], query: %{name: card_name})
      |> Map.get(:body)
      |> Poison.decode!
      |> Map.get("results")

    #TODO: Implement levenstein distance on results
    cond do
      results |> length > 0 -> (
          results
            |> hd
            |> Map.get("href")
            |> HTTPotion.get
            |> Map.get(:body)
            |> Poison.decode!
            |> (fn(json) ->
                IO.puts("----------------------------------------------------")

                Enum.map(["name", "strength"], fn(key) -> Map.get(json, key) end)
                |> Enum.join(", ")
                |> IO.puts

                faction = Map.get(json, "faction") |> Map.get("name")
                case Map.fetch(colors,faction) do
                  {:ok, value} ->  [value, faction] |> IO.ANSI.format(true) |> IO.write
                  :error  -> [colors["Default"], faction] |> IO.ANSI.format(true) |> IO.write
                end

                IO.write(", ")

                Map.get(json, "categories")
                |> Enum.map(fn(category) -> Map.get(category,"name") end)
                |> Enum.join(", ")
                |> IO.puts

                group = Map.get(json, "group") |> Map.get("name")
                case  Map.fetch(colors,group) do
                  {:ok, value} ->  [value, group] |> IO.ANSI.format(true) |> IO.puts
                  :error -> [colors["Default"], group] |> IO.ANSI.format(true) |> IO.puts
                end

                Map.get(json, "info") |> IO.puts
                IO.puts("----------------------------------------------------")
              end).()
      )
      results |> length == 0 -> IO.puts "No card found starting with #{card_name}"
    end

  end
end
