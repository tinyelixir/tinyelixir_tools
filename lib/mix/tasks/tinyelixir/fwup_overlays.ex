defmodule Mix.Tasks.Tinyelixir.FwupOverlays do
  def run(_) do
    "overlays"
    |> Path.expand(File.cwd!())
    |> File.ls!()
    |> IO.inspect()
  end
end
