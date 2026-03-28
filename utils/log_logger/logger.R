# ======================================================================
# Arquivo: logger.R
# Pipeline baseado em R para consumo de API IBGE, processamento e 
# implementação de relatório Estatístico.
# Autor: Carlos da Costa
# Localização: Recife, Pernambuco - Brasil
# Data de criação: 28/03/2026
# Última modificação: 28/03/2026
# Versão: 1.0.0
# Ambiente: development
#
# ----------------------------------------------------------------------
# Descrição:
# Módulo responsável pela configuração centralizada do sistema de logs
# do pipeline.
#
# Este script define:
#   - Nível de log (INFO)
#   - Formato das mensagens
#   - Saída (console e/ou arquivo)
#   - Timezone e timestamp
#   - Política de sobrescrita de arquivos
#
# O comportamento do logger é configurado dinamicamente via config.yaml.
# ----------------------------------------------------------------------

library(logger)
library(glue)
library(yaml)
library(here)

# ------------------------------------------------------
# 2. Função responsável pela configuração do log
# ------------------------------------------------------
setup_logger <- function() {
  
  tryCatch({
    
    # --------------------------------------------------------
    # Ler arquivos de configuração
    # --------------------------------------------------------
    config_path <- suppressWarnings(
      yaml::read_yaml(here("config_yaml", "paths.yaml"))
    )
    
    config_logging <- suppressWarnings(
      yaml::read_yaml(here("config_yaml", "logging.yaml"))
    )  
    
    # --------------------------------------------------------
    # Valida campos obrigatórios
    # --------------------------------------------------------
    if (is.null(config_logging$logging$level)) {
      stop("Campo logging.level não encontrado em logging.yaml")
    }
    
    if (is.null(config_path$logs$file)) {
      stop("Campo logs.file não encontrado em paths.yaml")
    }
    
    
    # --------------------------------------------------------
    # Configurar logger
    # --------------------------------------------------------
    # Nível mínimo de log
    log_threshold(config_logging$logging$level)
    
    # --------------------------------------------------------
    # Define formato da mensagem do log
    # --------------------------------------------------------
    # Função do pacote logger que permite usar interpolação (glue)
    log_layout(layout_glue_generator(
      format = config_logging$format$format
    ))
    
    log_path <- config_paths$logs$file
    
    # Validação 
    if (is.null(log_path) || !is.character(log_path) || length(log_path) != 1) {
      stop("logs$file inválido no YAML")
    }
    
    # --------------------------------------------------------
    # Cria diretório, caso não exista
    # --------------------------------------------------------
    log_dir <- dirname(log_path)
    
    if (!dir.exists(log_dir)) {
      dir.create(log_dir, recursive = TRUE)
    }
    
    # --------------------------------------------------------
    # Define para onde o log será enviado.
    # --------------------------------------------------------
    log_appender(appender_file(config_path$logs$file))
    
    # --------------------------------------------------------
    # Registra mensagem de nível INFO
    # --------------------------------------------------------
    log_info("Logger configurado com sucesso.")
    
  },
  
  # ----------------------------------------------------------
  # Tratamento de ERRO
  # ----------------------------------------------------------
  error = function(e) {
    
    # Como o logger pode não estar pronto ainda,
    # usamos message() como fallback
    message("ERRO ao configurar logger: ", e$message)
    
    # Opcional: tentar usar error_handler
    if (file.exists("utils/error_handler.R")) {
      source("utils/error_handler.R")
      handle_error(e, step = "SETUP_LOGGER")
    } else {
      stop(e$message)
    }
  },
  
  # ----------------------------------------------------------
  # Avisos
  # ----------------------------------------------------------
  warning = function(w) {
    message("Aviso no setup_logger: ", w$message)
  }
  
  )
}