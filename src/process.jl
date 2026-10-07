using JSON3
using Dates

function load_processed_ids(path::String)
    ids = Set{String}()
    isfile(path) || return ids
    for line in eachline(path)
        isempty(strip(line)) && continue
        rec = JSON3.read(line)
        push!(ids, String(rec.id))
    end
    return ids
end

function append_filtered(path::String, id::String, relevant::Bool;
                         summary::AbstractString="")
    #                   ^^^^^^^^^^^^^^^^ принимает и String, и SubString
    dir = dirname(path)
    isempty(dir) || mkpath(dir)
    record = relevant ?
        (id=id, relevant=true,  summary=String(summary)) :
        (id=id, relevant=false)
    open(path, "a") do io
        println(io, JSON3.write(record))
    end
end

function append_summary_md(path::String, article::Article, summary::String)
    dir = dirname(path)
    isempty(dir) || mkpath(dir)
    open(path, "a") do io
        println(io, "## ", article.id, " — ", article.title)
        println(io)
        println(io, "**PDF:** ", article.pdf_url)
        println(io)
        println(io, summary)
        println(io)
        println(io, "---")
        println(io)
    end
end

function process_articles(articles::Vector{Article}, interests::String;
                          filtered_path::String,
                          summaries_path::String,
                          pause::Float64 = 0.5)
    processed = load_processed_ids(filtered_path)
    @info "Уже обработано" count=length(processed)

    n_total = length(articles)
    n_new   = 0
    n_kept  = 0

    for (i, a) in enumerate(articles)
        if a.id in processed
            continue
        end

        n_new += 1
        @info "Обработка" progress="$i/$n_total" id=a.id title=first(a.title, 60)

        try
            relevant = is_relevant(a, interests)

            if relevant
                summary = summarize(a)
                append_filtered(filtered_path, a.id, true; summary=summary)
                append_summary_md(summaries_path, a, summary)
                n_kept += 1
                @info "  → релевантна, пересказ сохранён"
            else
                append_filtered(filtered_path, a.id, false)
                @info "  → пропущена"
            end
        catch e
            @warn "Ошибка на статье — пропускаю" id=a.id exception=(e, catch_backtrace())
            try
                append_filtered(filtered_path, a.id, false)
            catch
            end
        end

        sleep(pause)
    end

    return (total=n_total, new=n_new, kept=n_kept)
end