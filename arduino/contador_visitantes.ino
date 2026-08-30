// Contador de Visitantes - Mundo das Profissoes (Engenharia Eletrica)
// Dois sensores infravermelhos de obstaculo decidem a direcao pela ORDEM
// que disparam, nao pelo sensor sozinho: S1 = lado do corredor (fora),
// S2 = lado da sala (dentro).
//   S1 dispara -> S2 dispara depois  = ENTRADA
//   S2 dispara -> S1 dispara depois  = SAIDA (nao conta)
// Arduino separado do jogo de reflexo, USB proprio ate o notebook.

const int S1_PIN = 4;
const int S2_PIN = 5;
const unsigned long WINDOW_MS = 1500; // tempo max entre os dois sensores pra contar como cruzamento

bool s1Prev = HIGH;
bool s2Prev = HIGH;
char pending = 0;        // 'A' = S1 disparou primeiro, 'B' = S2 disparou primeiro
unsigned long pendingAt = 0;

void setup() {
  Serial.begin(9600);
  pinMode(S1_PIN, INPUT_PULLUP);
  pinMode(S2_PIN, INPUT_PULLUP);
}

void loop() {
  bool s1 = digitalRead(S1_PIN);
  bool s2 = digitalRead(S2_PIN);
  unsigned long now = millis();

  if (pending != 0 && now - pendingAt > WINDOW_MS) {
    pending = 0; // ninguem completou o cruzamento a tempo, esquece
  }

  bool s1Fired = (s1Prev == HIGH && s1 == LOW);
  bool s2Fired = (s2Prev == HIGH && s2 == LOW);

  if (s1Fired) {
    if (pending == 'B') {
      Serial.println("EXIT");
      pending = 0;
    } else if (pending == 0) {
      pending = 'A';
      pendingAt = now;
    }
  }

  if (s2Fired) {
    if (pending == 'A') {
      Serial.println("ENTRY");
      pending = 0;
    } else if (pending == 0) {
      pending = 'B';
      pendingAt = now;
    }
  }

  s1Prev = s1;
  s2Prev = s2;
}
