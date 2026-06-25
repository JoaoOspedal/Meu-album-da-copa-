# Meu-album-da-copa-
Projeto de um álbum da copa do mundo 2026 baseado em Flutter

Este repositório contém apenas o **frontend** do app, com dados mockados localmente (sem backend/API).

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado e configurado (`flutter doctor` sem erros para a plataforma escolhida).
- Um dispositivo/destino para executar: emulador ou aparelho Android, simulador iOS, Chrome/Edge (web), ou Windows/macOS/Linux desktop (requer as ferramentas nativas de cada plataforma, ex.: Visual Studio com "Desktop development with C++" no Windows).

## Como rodar

1. Clone o repositório e entre na pasta do projeto:
   ```bash
   git clone https://github.com/JoaoOspedal/Meu-album-da-copa-.git
   cd Meu-album-da-copa-
   ```
2. Instale as dependências (isso também gera os arquivos de localização a partir dos `.arb`):
   ```bash
   flutter pub get
   ```
3. Veja quais destinos estão disponíveis na sua máquina:
   ```bash
   flutter devices
   ```
4. Execute o app em um dos destinos listados, por exemplo:
   ```bash
   flutter run -d chrome      # navegador
   flutter run -d windows     # app desktop Windows
   flutter run                # deixa o Flutter escolher/perguntar o destino
   ```

> **Nota:** se o projeto estiver em uma pasta com acentos no caminho (ex.: `Repositórios`), o comando `flutter build web`/`run -d chrome` pode falhar por um bug do compilador de shaders do Flutter no Windows ao lidar com caracteres acentuados no caminho. Caso isso ocorra, mova/copie o projeto para um caminho sem acentos antes de rodar.

## Outros comandos úteis

- `flutter analyze` — checagem estática do código.
- `flutter test` — executa os testes automatizados.
