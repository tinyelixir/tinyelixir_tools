defmodule Mix.Tasks.Tinyelixir.FwupOverlays do
  @moduledoc """
  This module is responsible for copying overlays into place to be ussed by fwup
  as well as updating the fwup.conf file from an eex template to include them in
  the firmware.
  """

  def run(_) do
    overlay_files()
    |> copy_files_into_fwup_include()
    |> evaluate_fwup_template()
  end

  defp overlay_files do
    "overlays"
    |> Path.expand(File.cwd!())
    |> File.ls!()
  end

  defp copy_files_into_fwup_include(files) do
    Enum.each(files, fn overlay_file ->
      File.cp!(
        Path.expand(overlay_file, overlays_path()),
        Path.expand(overlay_file, fwup_include_path())
      )
    end)

    files
  end

  defp evaluate_fwup_template(files) do
    EEx.eval_file(fwup_template_path(), assigns: [overlay_files: files])
  end

  defp overlays_path, do: Path.expand("overlays", File.cwd!())
  defp fwup_include_path, do: Path.expand("fwup_include", File.cwd!())
  defp fwup_template_path, do: Path.expand("fwup.conf.eex", File.cwd!())
end
