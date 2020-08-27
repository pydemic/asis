defmodule ICD10Extractor do
  @chapters ~w(I II III IV V VI VII VIII IX X XI XII XIII XIV XV XVI XVII XVIII XIX XX XXI XXII)

  @diseases_file_path "sandbox/diseases.csv"
  @sub_diseases_file_path "sandbox/sub_diseases.csv"

  def playbook do
    File.rm(@diseases_file_path)
    diseases_file = File.open!(@diseases_file_path, [:write, :append])
    IO.write(diseases_file, ~s("parent_block_id_1","parent_block_id_2","parent_block_id_3","id","name"\n))

    File.rm(@sub_diseases_file_path)
    sub_diseases_file = File.open!(@sub_diseases_file_path, [:write, :append])
    IO.write(sub_diseases_file, ~s("disease_id","id","name"\n))

    try do
      Enum.each(@chapters, &extract_from_chapters(&1, {diseases_file, sub_diseases_file}))
    rescue
      error ->
        IO.puts(Exception.message(error))
        File.close(diseases_file)
        File.close(sub_diseases_file)
    end
  end

  defp extract_from_chapters(chapter, files) do
    chapter
    |> request!()
    |> Enum.each(&extract_from_group(&1, files))
  rescue
    error -> IO.puts(Exception.message(error))
  end

  defp extract_from_group(%{"label" => label}, files, parents \\ []) do
    [id, name] = String.split(label, " ", parts: 2)

    if String.contains?(id, "-") do
      id
      |> request!()
      |> Enum.each(&extract_from_group(&1, files, [id | parents]))
    else
      {diseases_file, sub_diseases_file} = files

      case parents do
        [p1, p2, p3] -> IO.write(diseases_file, ~s("#{p1}","#{p2}","#{p3}","#{id}","#{name}"\n))
        [p1, p2] -> IO.write(diseases_file, ~s("#{p1}","#{p2}",,"#{id}","#{name}"\n))
        [p1] -> IO.write(diseases_file, ~s("#{p1}",,,"#{id}","#{name}"\n))
      end

      id
      |> request!()
      |> Enum.each(&extract_from_disease(&1, sub_diseases_file, id))
    end
  rescue
    error -> IO.puts(Exception.message(error))
  end

  defp extract_from_disease(%{"label" => label}, sub_diseases_file, disease_id) do
    [id, name] = String.split(label, " ", parts: 2)
    IO.write(sub_diseases_file, ~s("#{disease_id}","#{id}","#{name}"\n))
  end

  defp request!(id) do
    id
    |> get_url()
    |> Tesla.get!()
    |> Map.get(:body)
    |> Jason.decode!()
  end

  @url "https://icd.who.int/browse10/2019/en/JsonGetChildrenConcepts?"

  defp get_url(id) do
    @url <> "ConceptId=#{id}&useHtml=false&showAdoptedChildren=false"
  end
end

ICD10Extractor.playbook()
