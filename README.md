# 📌 IBGE Data Pipeline

Pipeline de ingestão, processamento e análise de dados da API do IBGE, desenvolvido em R com foco em boas práticas de 
engenharia de dados, modularização e resiliência.

## 📌 Visão Geral

Este projeto implementa um pipeline completo para:

* Consumo de dados da API do IBGE
* Tratamento e padronização das séries temporais
* Cálculo de métricas estatísticas
* Preparação de dados para visualização
* Execução resiliente com retry automático
* Logging estruturado para monitoramento

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
├── reoprts/
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


















