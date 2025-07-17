# README - Aplicação Monorepo (Rails + React/Vite)

## Visão Geral

Este projeto é um monorepo que contém dois serviços principais:

- Backend: API Ruby on Rails - ruby: "3.3.0" e rails: "7.1.3"
```Bash
ruby "3.3.0"
gem "rails", "~> 7.1.3"
```
- Frontend: Aplicação frontend em React com Vite - react: "19.1.0" e vite: "7.0.0"
```Bash
"react": "^19.1.0"
"vite": "^7.0.0"
```

Utilizei docker e docker-compose para facilitar a construção, execução e desenvolvimento local dos serviços.

---

## Requisitos

- Docker (versão recente)
- Docker Compose (versão compatível com Docker instalado)
- Git (para clonar o repositório)

---

## Instalação e Setup

### 1. Clone o repositório

```bash
git clone https://github.com/gianniresende/port-challenge.git
cd port-challenge
```

### 2. Configure variáveis de ambiente

Copie o arquivo `.env.example` para `.env` na raiz do projeto e dentro da pasta frontend `.env.example` para `.env`.

```bash
cp .env.example .env
```

### 3. Build das imagens Docker

Execute o comando abaixo para construir as imagens do backend e frontend, instalando as dependências necessárias:

Nome sugerido para o projeto
```bash
docker-compose --project-name teamtalk
```

---

## Rodando a aplicação

### Desenvolvimento

Para subir todos os serviços (backend, banco, redis, frontend, sidekiq):

```bash
docker-compose --project-name teamtalk up -d --build
```

- O backend estará disponível em `http://localhost:3000`
- O frontend estará disponível em `http://localhost:5173`
- MailHog para receber os emails de usuários cadastrados basta acessar `http://localhost:8025`


### Comando para entrar no container backend (Rails)

```bash
docker-compose --project-name teamtalk exec backend bash
```

### Comando para entrar no container frontend

```bash
docker-compose --project-name teamtalk exec front bash
```

---

## Rodando testes

Para rodar os testes automatizados do backend:

```bash
docker-compose --project-name teamtalk run --rm test bundle exec rspec
```

---

## User admin criado no seed

```Bash
email: admin@teamtalk.com
password: password123
```

---

## Observações importantes

- O volume `node_modules` do frontend é gerenciado dentro do container para evitar conflitos entre dependências locais e do container.

- O backend depende dos serviços `db` (Postgres) e `redis`, que são iniciados automaticamente pelo Docker Compose.

- Migrations e seeds serão aplicados automaticamente, mas se por algum motivo perceber que o bd não está preparado adequadamente,
  os seguintes comando podem resolver.

```Bash
docker-compose --project-name teamtalk exec backend bash
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
```

## Acesso ao container do backend e obter o token para acesso externo autorizado (Sistema de RH) - desenvolvimento


```bash
docker-compose --project-name teamtalk exec backend bash
```

```bash
bundle exec rails c
```

```irb
User.find_by(email: 'parceiro-rh@sistema.com').api_token.token
```

## Criar user via integração - ambiente dev
```bash
curl -X POST http://localhost:3000/api/v1/users \
  -H "X-Api-Token: Bearer token obtido no passo anterioration" \
  -H "Accept: */*" \
  -d '{
    "email": "user.test@gmail.com",
    "name": "User Teste",
    "role": "employee"
  }'
```

## Inativar user via integração - ambiente dev
```bash
curl -X PATCH http://localhost:3000/api/v1/users/{user_id}/inactivate \
  -H "X-Api-Token: Bearer token obtido no passo anterior" \
  -H "Accept: */*" \
  -d ''
```

---

## Estrutura do projeto

- `/backend` - código Ruby on Rails
- `/frontend` - código frontend em React/Vite
- `docker-compose.yml` - configura os serviços Docker
- `.env` - arquivo de variáveis de ambiente

---

## Backend (Rails)

### Principais decisões técnicas
- Arquitetura limpa com separação da lógica de filtros em Service Object (`UserFilter`).
- Uso de Form Object (`UserWebhookParams`) para validação dos parâmetros recebidos.
- Controle de acesso via Policies, garantindo regras baseadas em roles (admin, manager, hr, employee).
- Serialização padronizada usando `JSONAPI::Serializer` para respostas performáticas e consistentes.
- Cache com chave dinâmica para otimização de consultas.
- Utilização de Redis para cache e Sidekiq para jobs assíncronos.
- Banco de dados PostgreSQL com otimizações.
- Autenticação via Devise e DeviseTokenAuth.

### Boas práticas aplicadas
- Adoção dos princípios SOLID (principalmente SRP e OCP).
- Tratamento de erros com logs detalhados.
- Envio de e-mails assíncrono.

---

## Frontend (React + Vite)

### Tecnologias utilizadas
- React 19 e React Router DOM para SPA.
- TypeScript para segurança de tipos.
- TailwindCSS para estilização rápida e responsiva.
- ESLint com plugins para qualidade e padrões de código.
- Vite para desenvolvimento rápido e build otimizado.

### Estado global
- Gerenciamento de estado via React Context para evitar prop drilling e manter organização.

### Scripts disponíveis
- `dev` — ambiente de desenvolvimento com hot reload.
- `build` — build otimizado para produção.
- `lint` — verificação de qualidade do código.
- `preview` — preview local da build.

---

## Infraestrutura e Deployment

- Ambiente local com Docker Compose para backend, frontend, banco, Redis, Sidekiq e MailHog.
- Deploy em ambiente de produção AWS utilizando EC2.
- Deploy manual devido a limitação de tempo.
- Variáveis de ambiente configuradas para segurança.

---

## Melhorias Futuras

- Implementação de pipeline CI/CD para automação de build, testes e deploy (GitHub Actions, GitLab CI, AWS CodePipeline).
- Ampliação dos testes automatizados no frontend e backend.
- Avaliação de soluções avançadas para gerenciamento de estado no frontend (Redux, Zustand, React Query).
- Monitoramento e logging centralizado para produção.
- Otimizações adicionais de cache e performance para alta carga.

---

## Conclusão

Este projeto evidencia uma solução completa e madura, abrangendo arquitetura backend, frontend moderno, infraestrutura em nuvem, boas práticas de desenvolvimento e foco em qualidade e escalabilidade.


## Contatos e Suporte

Em caso de dúvidas ou problemas, abra uma issue no repositório ou entre em contato com o desenvolvedor.
gianniresende@gmai.com
