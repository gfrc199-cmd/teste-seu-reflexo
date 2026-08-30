# Jogo de Reflexo — Mundo das Profissões (Engenharia Elétrica)

Protótipo funcional: Arduino mede o tempo de reação e a página web mostra tudo em tela cheia na TV, com ranking salvo localmente (sem internet, sem servidor).

## Ligação (Arduino Uno/Nano)

| Componente | Pino |
|---|---|
| LED Jogador 1 (+ resistor ~220Ω) | Pino 8 |
| Botão Jogador 1 | Pino 2 (usa `INPUT_PULLUP` — outra perna do botão vai no GND) |
| LED Jogador 2 (+ resistor ~220Ω) | Pino 9 |
| Botão Jogador 2 | Pino 3 (outra perna no GND) |

Pra jogo de 1 jogador só, monta só o par do Jogador 1 — o código já suporta rodar com 1 ou 2.

## Como rodar no dia do evento

1. Abra o `arduino/jogo_reflexo.ino` na IDE do Arduino, selecione a placa/porta certa e faça o upload.
2. Conecte o Arduino no notebook via USB (o mesmo notebook que vai na TV via HDMI).
3. Abra um terminal na pasta `web/` e rode um servidor local (necessário pro navegador permitir Web Serial):
   ```
   python3 -m http.server 8000
   ```
4. Abra **Chrome ou Edge** (Web Serial não funciona no Firefox/Safari) em `http://localhost:8000`.
5. Aperte F11 pra tela cheia, jogue na TV.
6. Clique em **"Conectar Arduino"** e escolha a porta serial na janela que o navegador abrir.
7. Digite o(s) nome(s), clique em **"+ Jogador 2"** se for modo disputa, e **"Começar"**.

## Funcionamento

- O Arduino espera um comando `START:1` ou `START:2` pela serial.
- Espera um tempo aleatório (2 a 6s) — se alguém apertar o botão antes da hora, dá **"saiu cedo"** (falsa largada).
- Quando o LED acende, mede o tempo até cada botão ser apertado e manda o resultado pela serial (`RESULT:P1:287`).
- A página web recebe, mostra o tempo na tela, salva no ranking (guardado no navegador, sem precisar de internet) e depois de alguns segundos volta pra tela de ranking.

## Por que assim (decisões de projeto)

- **Tudo local, sem servidor/internet** — não depende de wifi do evento nem da infraestrutura de produção da empresa; roda 100% offline no notebook.
- **Ranking persistido no navegador** (`localStorage`) — sobrevive a recarregar a página, mas fica só naquele notebook (do jeito que precisa ser pra esse uso).
- **Web Serial API** — evita precisar de uma placa com USB nativo (Leonardo/Pro Micro); funciona com Arduino Uno/Nano comum.

## Não testado ainda

Este é um protótipo de código — ainda não foi rodado com hardware real. Antes do evento, testem com o Arduino de verdade e ajustem tempos/pinos conforme necessário.
