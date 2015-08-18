module Setting

export doc_items
export juliadoc, phdthesis
export get_src_path, get_codex_path, is_scripts

type DocSet
  name
  files
end

type DocItem
  codex_path
  src_path
end

juliadoc = DocSet("julia/doc", """
                    index.rst
                    manual/introduction.rst
                    manual/getting-started.rst
                    manual/variables.rst
                    manual/integers-and-floating-point-numbers.rst
                  """ |> split)

phdthesis = DocSet("phdthesis", """
                     chap6.tex
                   """ |> split)

is_scripts = "scripts" == basename(pwd())

function get_src_path(name, file)
  src_dir = is_scripts ? "../src" : "src"
  extension = "txt"
  normpath(src_dir, name, "$file.$extension")
end


function get_codex_path(work_path, sub, is_scripts)
  codex_path = ""
  if isdir(normpath(work_path, sub))
    codex_path = work_path
  else
    codex_path = is_scripts ? "../codex" : "codex"
  end
  codex_path
end


function get_doc_items(sets)
  work_path = is_scripts ? "../.." : ".."
  codex_path = get_codex_path(work_path, juliadoc.name, is_scripts)

  items = DocItem[]
  for set in sets
    for file in set.files
      item = DocItem(
        normpath(codex_path, set.name, file),
        get_src_path(set.name, file)
      )
      push!(items, item)
    end
  end
  items
end

doc_items = get_doc_items([juliadoc, phdthesis])

end
