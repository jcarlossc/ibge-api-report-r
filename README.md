# 📌 IBGE Data Pipeline

Pipeline de ingestão, processamento, análise de dados e geração de relatório da API do IBGE, desenvolvido em R com foco em boas práticas de 
engenharia de dados, modularização e resiliência.

## 📌 Relatório R Markdown
[📄 Ver relatório completo](reports/relatorio.pdf)<br>
<a href="reports/relatorio.pdf" download="Relatório_API_IBGE.pdf" target="_blank">📥 Baixar relatório completo</a><br>

## 📌 Visão Geral

Este projeto implementa um pipeline completo para:

* Consumo de dados da API do IBGE
* Tratamento e padronização das séries temporais
* Cálculo de métricas estatísticas
* Preparação de dados para visualização
* Execução resiliente com retry automático
* Logging estruturado para monitoramento
* Geração de Relatório

## 📌 Arquitetura do Projeto
```
ibge-api-report-r/
|
├── .gitignore
├── .RData
├── .Rhistory
├── .Rprofile
├── config_yaml/
│       ├── config_env.yaml
│       ├── logging.yaml
│       └── paths.yaml
├── ibge-api-report-r.Rproj
├── LICENSE
├── logs/
|     └── pipeline.log
├── main.R
├── README.md
├── renv/
├── renv.lock
├── reports/
│       ├── ibge.jpg
│       ├── relatorio.pdf
│       └── relatorio.Rmd
├── src/
│     ├── api/
│     |     └── api_processing.R
│     ├── graphics/
│     |     └── graphics_processing.R
│     └── statistic/
│           └── statistical_processing.R
└── utils/
      ├── error/
      |     └── error_handler.R.R
      ├── helper/
      |     └── helpers.R
      └── log_logger/
            └── logger.R
```

## 📌 Tecnologias Utilizadas

| Tecnologia | Descrição |
| ---------- | --------- |
| Linguagem R | análise de dados |
| httr | requisições HTTP |
| jsonlite | parsing JSON |
| logger | logging estruturado |
| yaml | configuração externa |
| here | gerenciamento de caminhos |
| glue | interpolação de strings |
| RStudio | IDE |

## 📌 Fluxo do Pipeline
1. Leitura de configurações via YAML
2. Inicialização do sistema de logging
3. Iteração sobre múltiplos indicadores
4. Consumo da API com mecanismo de retry
5. Transformação dos dados em tibble
6. Cálculo de métricas estatísticas
7. Preparação para visualização
8. Retorno estruturado dos resultados
9. Geração de Relatório

## 📌 Indicadores Coletados
* Turismo (chegada de turistas)
* Exportação
* Importação
* PIB
* População

## 📌 Mecanismo de Retry
O pipeline implementa retry automático para garantir robustez em falhas de rede:
```
retry:
  max_attempts: 3
  wait_seconds: 5
```
✔ Evita falhas intermitentes<br>
✔ Aumenta confiabilidade do pipeline<br>

## 📌 Estrutura dos Dados
Cada indicador retorna:
```
list(
  values_tibble = tibble(ano, valor),
  metadata_tibble = tibble(pais_nome, titulo, assunto)
)
```

## 📌 Métricas Calculadas
* Média
* Mediana
* Mínimo / Máximo
* Desvio padrão
* Crescimento total
* Crescimento percentual
* CAGR

## 📌 Logging
O projeto utiliza logging estruturado:<br>
Exemplo:<br>
```
[2026-04-02 21:58:39.052295] INFO - Logger configurado com sucesso.
[2026-04-02 21:58:39.171632] INFO - ##### Início do pipeline - main() #####
[2026-04-02 21:58:39.178548] INFO - Coletando indicador: *** turistas ***
[2026-04-02 21:58:39.27281] INFO - Tentativa 1 de 3
[2026-04-02 21:58:39.471399] INFO - Início do processamento da API IBGE
[2026-04-02 21:58:39.477265] INFO - Realizando requisição HTTP
[2026-04-02 21:58:40.146447] INFO - Estrutura da API validada
[2026-04-02 21:58:40.172424] INFO - Transformação dos dados concluída
[2026-04-02 21:58:40.177981] INFO - Finalizando execução da função get_api
```

## 📌 Como Executar
1. clone o repositório e acesse o diretório
```
git clone https://github.com/jcarlossc/ibge-api-report-r.git
cd ibge-api-report-r
```
2. Restaure as dependências:
```
renv::restore()
```
OBSERVAÇÃO: diferentemente de projetos comuns em R, o intuito do projeto ibge-api-report-r é a geração de relatório em PDF, por isso, é necessários seguir
as duas etapas anteriores e:

4. Acesse o arquivo relatótio:
```
ibge-api-report-r/reports/relatorio.Rmd
```
5. No Rstudio, clicar no botão Knit ou usar o atalho ```Ctrl + Shift + K```: esse procedimento vai executar o projeto e gerar o relatório em PDF.

## 📌 Tratamento de Erros

* Validação de entrada
* Retry automático
* Logs detalhados
* Fail-safe por indicador

## 📌 Boas Práticas Aplicadas

✔ Código modular (separação de responsabilidades)<br>
✔ Configuração externa (YAML)<br>
✔ Logging estruturado<br>
✔ Tratamento robusto de erros<br>
✔ Funções reutilizáveis<br>
✔ Pipeline escalável<br>

## 📌 Melhorias Futuras

* Paralelização do consumo da API
* Exportação automática (CSV/Parquet)
* Dashboard interativo (Shiny ou Plotly)
* Testes automatizados (testthat)
* Containerização com Docker

## 📌 Licença
Este projeto está licenciado sob MIT License.

## 📌 Contato
* Recife, PE - Brasil<br>
* Telefone: +55 81 99712 9140<br>
* Telegram: @jcarlossc<br>
* Pypi: https://pypi.org/user/jcarlossc/<br>
* Blogger linguagem R: [https://informaticus77-r.blogspot.com/](https://informaticus77-r.blogspot.com/)<br>
* Blogger linguagem Python: [https://informaticus77-python.blogspot.com/](https://informaticus77-python.blogspot.com/)<br>
* Email: jcarlossc1977@gmail.com<br>
* LinkedIn: https://www.linkedin.com/in/carlos-da-costa-669252149/<br>
* GitHub: https://github.com/jcarlossc<br>
* Kaggle: https://www.kaggle.com/jcarlossc/  
* Twitter/X: https://x.com/jcarlossc1977<br>



