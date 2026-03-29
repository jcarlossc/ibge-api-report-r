


library(yaml)
library(here)



config_paths <- suppressWarnings(
  yaml::read_yaml(here("config_yaml", "paths.yaml"))
)

source(here(config_paths$src$api))
source(here(config_paths$utils$logger))
source(here(config_paths$src$graphic))
source(here(config_paths$src$statistic))


setup_logger()

url <- paste0(config_paths$api_ibge$url, "/77849/")

api <- get_api(url)


api
get_graphics(api)


get_statistics(api$values_tibble)
