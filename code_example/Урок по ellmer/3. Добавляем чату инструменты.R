library(ellmer)

chat <- chat_gemini()

chat$chat('Какое текущее время сейчас по Киеву?')

#' Gets the current time in the given time zone.
#'
#' @param tz The time zone to get the current time in.
#' @return The current time in the given time zone.
get_current_time <- function(tz = "UTC") {
  format(Sys.time(), tz = tz, usetz = TRUE)
}

chat$register_tool(tool(
  get_current_time,
  "Получить текущее время в указанном часовом поясе.",
  tz = type_string(
    "Часовой пояс. По умолчанию `\"UTC\"`.",
    required = FALSE
  )
))

chat$chat('Какое текущее время сейчас по Киеву?')
