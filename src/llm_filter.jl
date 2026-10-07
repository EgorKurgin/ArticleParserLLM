"""
    build_filter_prompt(article::Article, interests::String) -> String

Собирает промпт для проверки релевантности одной статьи.
"""
function build_filter_prompt(article::Article, interests::String)
    return """
Ты — научный ассистент, помогающий отбирать статьи по интересам пользователя.

Интересы пользователя:
$interests

Ниже — одна статья с arXiv.

Title: $(article.title)
Abstract: $(article.abstract)

Вопрос: релевантна ли эта статья интересам пользователя?

Ответь ровно одним словом:
- true — если статья явно касается хотя бы одной из тем
- false — если статья не имеет отношения к этим темам

Не пиши ничего кроме true или false. Не объясняй свой ответ.
"""
end

"""
    parse_bool_response(text::String) -> Union{Bool, Nothing}

Парсит ответ модели. Возвращает true/false, либо nothing, если ответ не распознан.
"""
function parse_bool_response(text::String)
    s = lowercase(strip(text))
    occursin("true",  s) && return true
    occursin("false", s) && return false
    return nothing
end

"""
    is_relevant(article::Article, interests::String; kwargs...) -> Bool

Проверяет, релевантна ли статья интересам. Возвращает true/false.
Если модель ответила неоднозначно — возвращает false и логирует предупреждение.
"""
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