library(yaml)
library(here)

config_paths <- suppressWarnings(
  yaml::read_yaml(here("config_yaml", "paths.yaml"))
)
config_retry <- suppressWarnings(
  yaml::read_yaml(here("config_yaml", "config_env.yaml"))
)

source(here(config_paths$src$api))
source(here(config_paths$utils$logger))
source(here(config_paths$src$graphic))
source(here(config_paths$src$statistic))
source(here(config_paths$utils$helper))

setup_logger()

url <- paste0(config_paths$api_ibge$url, "/77849/")

dados <- retry_manual(
  function() get_api(url),
  attempts = 3,
  wait = 5
)

get_graphics(dados)

get_statistics(dados$values_tibble)
