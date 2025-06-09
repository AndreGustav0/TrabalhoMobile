# Crypto Market Cap - Flutter App

Uma aplicação Flutter que consome a API do CoinMarketCap para exibir informações sobre criptomoedas em tempo real.

## Pré-requisitos

Antes de começar, certifique-se de ter instalado:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versão 3.0 ou superior)
- [Dart SDK](https://dart.dev/get-dart) (incluído com Flutter)
- Um navegador web (Chrome recomendado)
- Editor de código (VS Code, Android Studio, ou similar)

## Como configurar e executar o projeto

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd api_market_cap_coin
```

### 2. Instale as dependências

```bash
flutter pub get
```

### 3. Execute o projeto

**IMPORTANTE:** Para executar este projeto no navegador, você deve usar o comando específico abaixo(para evitar problemas com cors ):

```bash
flutter run -d chrome --web-browser-flag "--disable-web-security"
```

#### Por que usar `--disable-web-security`?

Este projeto consome a API do CoinMarketCap diretamente do navegador. Por questões de segurança, os navegadores implementam uma política chamada **CORS (Cross-Origin Resource Sharing)** que bloqueia requisições entre diferentes domínios.

Como a API do CoinMarketCap não possui configuração CORS adequada para aplicações web client-side, precisamos desabilitar temporariamente essa verificação no Chrome durante o desenvolvimento.


### 4. Comandos alternativos

Se você quiser executar em outros dispositivos:

```bash
# Para Android (com dispositivo conectado)
flutter run -d android

# Para iOS (apenas no macOS)
flutter run -d ios

# Para Windows desktop
flutter run -d windows
```

## Estrutura do Projeto

```
lib/
├── configs/
│   ├── api_config.dart          # Configurações da API
│   └── injection_container.dart  # Injeção de dependências
├── core/
│   ├── library/
│   │   └── constants.dart        # Constantes da aplicação
│   └── service/
│       └── http_service.dart     # Serviço HTTP
├── data/
│   ├── datasources/
│   │   └── crypto_remote_data_source.dart  # Fonte de dados remota
│   └── repositories/
│       └── crypto_repository.dart          # Implementação do repositório
├── domain/
│   ├── entities/
│   │   └── crypto_currency_entity.dart     # Entidades de domínio
│   └── repositories/
│       └── i_crypto_repository.dart        # Interface do repositório
├── ui/
│   ├── pages/
│   │   └── crypto_list_page.dart           # Página principal
│   └── view_models/
│       └── crypto_view_model.dart          # ViewModel
└── main.dart                               # Ponto de entrada da aplicação
```

## Funcionalidades

- ✅ Listagem de criptomoedas populares
- ✅ Busca por símbolos específicos (ex: BTC, ETH)
- ✅ Exibição de preços em USD e BRL
- ✅ Interface responsiva e moderna
- ✅ Loading states e tratamento de erros
- ✅ Pull-to-refresh
- ✅ Detalhes expandidos de cada criptomoeda

## Configuração da API

### Obtendo sua própria chave da API

**IMPORTANTE:** Este projeto inclui uma chave de API de demonstração que pode ter limitações. Para uso completo, você deve obter sua própria chave:

1. **Acesse o site do CoinMarketCap:**
   - Vá para [https://coinmarketcap.com/api/](https://coinmarketcap.com/api/)
   - Clique em "Get Your API Key Now"

2. **Crie uma conta gratuita:**
   - Faça o cadastro com seu email
   - Confirme sua conta
   - Acesse o dashboard da API

3. **Copie sua chave da API:**
   - No dashboard, você verá sua API Key
   - Copie a chave (formato: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`)

### Configurando sua chave no projeto

### Planos disponíveis

- **Basic (Gratuito):** 333 chamadas/dia, dados básicos
- **Hobbyist ($29/mês):** 3.33 chamadas/dia, mais endpoints
- **Startup ($79/mês):** 10.00 chamadas/dia, dados históricos
- **Standard ($249/mês):** 33.33 chamadas/dia, suporte prioritário

**Nota:** Para uso em produção, recomenda-se:
1. Mover a chave da API para variáveis de ambiente
2. Implementar um backend intermediário
3. Nunca expor chaves de API no código client-side
4. Usar um plano pago adequado ao volume de uso

## Tecnologias Utilizadas

- **Flutter** - Framework de desenvolvimento
- **Provider** - Gerenciamento de estado
- **HTTP** - Requisições de rede
- **Intl** - Formatação de números e datas
- **CoinMarketCap API** - Dados de criptomoedas
