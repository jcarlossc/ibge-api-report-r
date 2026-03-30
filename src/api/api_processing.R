# ======================================================================
# Arquivo: api_processing.R
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
# Realiza o consumo de uma API (ex: IBGE), valida a estrutura
# da resposta e retorna os dados tratados em formato tibble.
#
# Parâmetros:
# - url (character): Endpoint da API a ser consumida
#
# Retorno:
# - list:
#   - values_tibble: dados numéricos (ano e valor)
#   - metadata_tibble: informações descritivas da série
#
# Observações:
# - Possui validações de entrada e estrutura da API
# - Utiliza logging para rastreabilidade
# - Implementa tratamento de erros com tryCatch
# ------------------------------------------------------------

# --------------------------------------------------------
# Pacotes utilizados
# --------------------------------------------------------
library(jsonlite)
library(tibble)
library(logger)

# --------------------------------------------------------
# Função responsável pelo consumo da API IBGE
# --------------------------------------------------------
get_api <- function(url){
  
  # ----------------------------------------
  # Início do processamento
  # ----------------------------------------
  log_info("Início do processamento da API IBGE")
  
  tryCatch({
  
    # ----------------------------------------
    # Valida URL
    # ----------------------------------------
    if (missing(url) || !is.character(url) || nchar(url) == 0) {
      stop("[VALIDATION_ERROR] URL inválida")
    }
    
    if (!grepl("^https?://", url)) {
      stop("[VALIDATION_ERROR] URL deve começar com http ou https")
    }
    
    # ---------------------------------------------------------
    # 3. Consumo da API
    # ---------------------------------------------------------
    log_info("Realizando requisição HTTP")
    
    data_api <- fromJSON(url, simplifyVector = FALSE)
    
    # ----------------------------------------
    # Validação da estrutura da resposta
    # ----------------------------------------
    if (!is.list(data_api) || length(data_api) == 0) {
      stop("[DATA_ERROR] Estrutura da resposta inválida ou vazia")
    }
    
    if (is.null(data_api[[1]]$series)) {
      stop("[DATA_ERROR] Campo 'series' não encontrado")
    }
    
    if (is.null(data_api[[1]]$series[[1]]$serie)) {
      stop("[DATA_ERROR] Campo 'serie' não encontrado")
    }
    
    log_info("Estrutura da API validada")
    
    # ---------------------------------------------------------
    # Transformação dos dados
    # ---------------------------------------------------------
    values <- unlist(data_api[[1]]$series[[1]]$serie)
    
    values_tibble <- tibble(
      ano = as.integer(names(values)),
      valor = as.numeric(values)
    )
    metadata_tibble <- tibble(
      pais_nome = data_api[[1]]$series[[1]]$pais$nome,
      titulo = data_api[[1]]$indicador,
      assunto = data_api[[1]]$unidade$id
    )
    
    log_info("Transformação dos dados concluída")
    
    # ---------------------------------------------------------
    # Retorno final
    # ---------------------------------------------------------
    return(list(
      values_tibble = values_tibble,
      metadata_tibble = metadata_tibble
    ))
    
  }, 
    
    # ---------------------------------------------------------
    # Tratamento de erro
    # ---------------------------------------------------------
    error = function(e) {
      
      log_error(glue::glue("Erro ao consumir API: {e$message}"))
      
      # Repassa erro padronizado (importante para pipelines)
      stop(glue::glue("[API_ERROR] Falha na função get_api | {e$message}"))
  },
    
    # ---------------------------------------------------------
    # Tratamento de warnings
    # ---------------------------------------------------------
    warning = function(w) {
      
      log_warn(glue::glue("Aviso capturado: {w$message}"))
      
      # Continua execução sem interromper
      invokeRestart("muffleWarning")
    },
    
    # ---------------------------------------------------------
    # Finalização
    # ---------------------------------------------------------
    finally = {
    
    log_info("Finalizando execução da função get_api")
  })
}