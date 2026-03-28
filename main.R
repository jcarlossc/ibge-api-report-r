


library(yaml)
library(here)



config_paths <- suppressWarnings(
  yaml::read_yaml(here("config_yaml", "paths.yaml"))
)

source(here(config_paths$src$api))
source(here(config_paths$utils$logger))


setup_logger()

url <- paste0(config_paths$api_ibge$url, "/77849/")

api <- get_api(url)

class(api)
api
