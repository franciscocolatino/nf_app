## Pré-requisitos

Você precisa ter os as seguintes ferramentas instalados:

- **Docker**

## Passos para Configurar e Rodar o Projeto

### 1. Clone o Repositório

Primeiro, clone o repositório do projeto:

```bash
git clone git@github.com:franciscocolatino/nf_app.git
cd nf_app
```
Após isso, basta executar o docker:

```bash
sudo docker-compose up
```
Quando o docker terminar de instalar todas as dependencias, deve-se executar a criação do banco de dados

```bash
sudo docker-compose exec app rails db:create
```

Realizamos o migrate e seed

```bash
sudo docker-compose exec app rails db:migrate db:seed
```

Pronto, aplicação funcionando!
