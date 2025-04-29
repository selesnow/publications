save_chat <- function(chat_id, chat_object) {
  file_path <- file.path("chat_sessions", paste0(chat_id, ".rds"))
  saveRDS(chat_object, file_path)
}

load_chat <- function(chat_id) {
  file_path <- file.path("chat_sessions", paste0(chat_id, ".rds"))
  if (file.exists(file_path)) {
    return(readRDS(file_path))
  } else {
    return(NULL)
  }
}