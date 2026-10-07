function build_filter_prompt(article::Article, interests::String)
    return """
Ты — научный ассистент, помогающий отбирать статьи по интересам исследователя.

Интересы исследователя:
$interests

Ниже — одна статья с arXiv.

Title: $(article.title)
Abstract: $(article.abstract)

Вопрос: может ли эта статья быть полезна исследователю?

Правила:
- true — если статья касается хотя бы одной из его тем.
- false — Если статья из другой области или я никак ни могу использовать ее в своей работе.

Ответь ровно одним словом: true или false.
Не пиши ничего кроме этого слова. Не объясняй свой ответ.
"""
end

function parse_bool_response(text::String)
    s = lowercase(strip(text))
    occursin("true",  s) && return true
    occursin("false", s) && return false
    return nothing
end

function is_relevant(article::Article, interests::String; kwargs...)
    prompt = build_filter_prompt(article, interests)
    raw = ollama_generate(prompt;
                          temperature=0.0,   # максимально детерминированно
                          num_predict=10,    # ответ короткий
                          kwargs...)
    result = parse_bool_response(raw)

    if result === nothing
        @warn "Не удалось распарсить ответ модели" raw title=article.title
        return false
    end

    return result
end