# ----------------------------------------------------------------------
# Arquivo: helpers.R
# Pipeline baseado em R para consumo de API IBGE, processamento e 
# implementação de relatório Estatístico.
# Autor: Carlos da Costa
# Localização: Recife, Pernambuco - Brasil
# Data de criação: 30/03/2026
# Última modificação: 30/03/2026
# Versão: 1.0.0
# Ambiente: development
#
# ----------------------------------------------------------------------
# Descrição:
# Executa uma função com mecanismo de retry (repetição em caso
# de falha), útil para operações instáveis como chamadas de API,
# leitura de arquivos ou conexões externas.
#
# Parâmetros:
#   - func        : função a ser executada (deve ser passada sem executar)
#   - tentativas  : número máximo de tentativas (default = 3)
#   - espera      : tempo de espera (em segundos) entre tentativas (default = 5)
#
# Retorno:
#   - Retorna o resultado da função `func` caso seja bem-sucedida
#
# Erros:
#   - Interrompe a execução se todas as tentativas falharem
#   - Interrompe imediatamente se detectar erro de validação
#
# Observações:
#   - A função `func` deve ser passada como função anônima:
#       retry_manual(function() minha_funcao())
#   - Implementa tratamento básico de erros com tryCatch
# -------------------------------------------------------------

# --------------------------------------------------------
# Pacotes utilizados
# --------------------------------------------------------
library(logger)
library(glue)

retry_manual <- function(func, attempts, wait) {
  
  # --------------------------------------------------------
  # Loop de tentativas
  # --------------------------------------------------------
  for (i in 1:attempts) {
    
    log_info(glue("Tentativa {i} de {attempts}"))
    
    # --------------------------------------------------------
    # Execução protegida com tratamento de erro
    # --------------------------------------------------------
    result <- tryCatch({
      
      # Executa a função fornecida
      return(func())
      
    }, error = function(e) {
      
      log_warn(glue("Erro na tentativa {i}: {e$message}"))
      
      # --------------------------------------------------------
      # Regra de negócio:
      # Não realizar retry para erros de validação
      # --------------------------------------------------------
      if (grepl("VALIDATION_ERROR", e$message)) {
        stop(e)
      }
      
      # Retorna NULL para indicar falha controlada
      return(NULL)
    })
    
    # --------------------------------------------------------
    # Se execução bem-sucedida, retorna resultado
    # --------------------------------------------------------
    if (!is.null(result)) {
      return(result)
    }
    
    # --------------------------------------------------------
    # Aguarda antes da próxima tentativa
    # --------------------------------------------------------
    log_info(glue("Aguardando {wait}s para próxima tentativa"))
    Sys.sleep(wait)
  }
  
  # --------------------------------------------------------
  # Se todas as tentativas falharem, lança erro final
  # --------------------------------------------------------
  stop(sprintf("Todas as %d tentativas falharam.", tentativas))
}