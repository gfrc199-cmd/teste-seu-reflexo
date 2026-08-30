// Jogo de Reflexo - Mundo das Profissoes (Engenharia Eletrica)
// Le comandos START:1 / START:2 pela serial, controla LED(s) e botao(oes),
// e envia os resultados de volta pela serial pra pagina web mostrar na TV.

const int LED_PINS[2] = {8, 9};
const int BUTTON_PINS[2] = {2, 3};

enum State { IDLE, WAITING, LIT };
State state = IDLE;

unsigned long stateStartTime = 0;
unsigned long waitDuration = 0;
unsigned long lightOnTime = 0;
int activePlayers = 1;
bool pressed[2] = {false, false};

void setup() {
  Serial.begin(9600);
  for (int i = 0; i < 2; i++) {
    pinMode(LED_PINS[i], OUTPUT);
    pinMode(BUTTON_PINS[i], INPUT_PULLUP);
    digitalWrite(LED_PINS[i], LOW);
  }
  randomSeed(analogRead(A0));
}

void loop() {
  readSerialCommand();

  switch (state) {
    case WAITING:
      checkFalseStart();
      if (state == WAITING && millis() - stateStartTime >= waitDuration) {
        turnLightsOn();
      }
      break;
    case LIT:
      checkPresses();
      break;
    case IDLE:
      break;
  }
}

void readSerialCommand() {
  if (Serial.available()) {
    String cmd = Serial.readStringUntil('\n');
    cmd.trim();
    if (cmd == "START:1") beginRound(1);
    else if (cmd == "START:2") beginRound(2);
  }
}

void beginRound(int players) {
  activePlayers = players;
  pressed[0] = false;
  pressed[1] = false;
  digitalWrite(LED_PINS[0], LOW);
  digitalWrite(LED_PINS[1], LOW);
  waitDuration = random(2000, 6000); // espera aleatoria de 2 a 6s, evita "chutar" o momento
  stateStartTime = millis();
  state = WAITING;
}

void checkFalseStart() {
  for (int i = 0; i < activePlayers; i++) {
    if (digitalRead(BUTTON_PINS[i]) == LOW) {
      Serial.print("FALSE_START:P");
      Serial.println(i + 1);
      state = IDLE;
      return;
    }
  }
}

void turnLightsOn() {
  for (int i = 0; i < activePlayers; i++) {
    digitalWrite(LED_PINS[i], HIGH);
  }
  lightOnTime = millis();
  state = LIT;
  Serial.println("LIGHT_ON");
}

void checkPresses() {
  bool allPressed = true;
  for (int i = 0; i < activePlayers; i++) {
    if (!pressed[i]) {
      if (digitalRead(BUTTON_PINS[i]) == LOW) {
        pressed[i] = true;
        unsigned long reaction = millis() - lightOnTime;
        Serial.print("RESULT:P");
        Serial.print(i + 1);
        Serial.print(":");
        Serial.println(reaction);
        digitalWrite(LED_PINS[i], LOW);
      } else {
        allPressed = false;
      }
    }
  }
  if (allPressed) state = IDLE;
}
