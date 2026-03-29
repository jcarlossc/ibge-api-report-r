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
# Calcula métricas estatísticas para séries temporais.
#
# Parâmetros:
# - tibble_files -> tibble com colunas: ano e valor
#
# Retorno:
# - lista com métricas estatísticas
#
# Observações:
# - Possui validações de entrada e estrutura da API
# - Utiliza logging para rastreabilidade
# - Implementa tratamento de erros com tryCatch
# ------------------------------------------------------------

library(logger)
library(glue)

get_statistics <- function(tibble_files) {
  
  # ---------------------------------------------------------
  # Início do processamento estatístico
  # ---------------------------------------------------------
  log_info("Iniciando cálculo de estatístico")
  
  tryCatch({
  
    # ---------------------------------------------------------
    # Validação de entrada
    # ---------------------------------------------------------
    if (missing(tibble_files) || !is.data.frame(tibble_files)) {
      stop("[VALIDATION_ERROR] Objeto 'tibble_files' inválido ou não informado")
    }
    
    if (!all(c("ano", "valor") %in% names(tibble_files))) {
      stop("[VALIDATION_ERROR] O data.frame deve conter 'ano' e 'valor'")
    }
    
    if (!is.numeric(tibble_files$valor)) {
      stop("[VALIDATION_ERROR] A coluna 'valor' deve ser numérica")
    }
    
    # ---------------------------------------------------------
    # Ordenação dos dados
    # ---------------------------------------------------------
    tibble_files <- tibble_files[order(tibble_files$ano), ]
    
    # ---------------------------------------------------------
    # Estatísticas básicas
    # ---------------------------------------------------------
    media <- mean(tibble_files$valor, na.rm = TRUE)
    mediana <- median(tibble_files$valor, na.rm = TRUE)
    minimo <- min(tibble_files$valor, na.rm = TRUE)
    maximo <- max(tibble_files$valor, na.rm = TRUE)
    desvio_padrao <- sd(tibble_files$valor, na.rm = TRUE)
    
    # ---------------------------------------------------------
    # Crescimento total (%)
    # ---------------------------------------------------------
    valor_inicial <- tibble_files$valor[1]
    valor_final <- tibble_files$valor[nrow(tibble_files)]
    
    crescimento_total <- ((valor_final - valor_inicial) / valor_inicial) * 100
    
    # ---------------------------------------------------------
    # CAGR (crescimento anual)
    # ---------------------------------------------------------
    n_periodos <- nrow(tibble_files) - 1
    
    cagr <- ((valor_final / valor_inicial)^(1 / n_periodos) - 1) * 100
    
    # ---------------------------------------------------------
    # Variação ano a ano
    # ---------------------------------------------------------
    variacao_anual <- c(NA, diff(tibble_files$valor))
    
    # ---------------------------------------------------------
    # Crescimento percentual ano a ano
    # ---------------------------------------------------------
    crescimento_anual <- c(NA, diff(tibble_files$valor) / head(tibble_files$valor, -1) * 100)
    
    # ---------------------------------------------------------
    # Identificação de picos
    # ---------------------------------------------------------
    ano_max <- tibble_files$ano[which.max(tibble_files$valor)]
    ano_min <- tibble_files$ano[which.min(tibble_files$valor)]
    
    # ---------------------------------------------------------
    # Resultado 
    # ---------------------------------------------------------
    result <- list(
      resumo = list(
        media = media,
        mediana = mediana,
        minimo = minimo,
        maximo = maximo,
        desvio_padrao = desvio_padrao
      ),
      crescimento = list(
        crescimento_total_percentual = crescimento_total,
        cagr_percentual = cagr
      ),
      extremos = list(
        ano_max = ano_max,
        ano_min = ano_min
      )
    )
    
    log_info("Término do cálculo de estatístico")
    
    # ---------------------------------------------------------
    # Retorno
    # ---------------------------------------------------------
    return(result)
    
  },
  
  # ---------------------------------------------------------
  # Tratamento de erros
  # ---------------------------------------------------------
  error = function(e) {
    
    log_error(glue("Erro no cálculo de estatísticas: {e$message}"))
    
    stop(glue("[STATS_ERROR] Falha na função calcular_estatisticas | {e$message}"))
  },
  
  # ---------------------------------------------------------
  # Tratamento de warnings
  # ---------------------------------------------------------
  warning = function(w) {
    
    log_warn(glue("Aviso durante cálculo: {w$message}"))
    
    invokeRestart("muffleWarning")
  },
  
  # ---------------------------------------------------------
  # Finalização
  # ---------------------------------------------------------
  finally = {
    
    log_info("Término da execução da função get_statistics")
  })
}