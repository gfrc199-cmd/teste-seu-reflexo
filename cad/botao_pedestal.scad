// Pedestal do botão de 100mm (jogador 1 ou 2) — furo no topo pro botão arcade,
// canal interno pra passar o cabo CAT5 até a base do jogo.
//
// Corpo HEXAGONAL (em vez de tubo liso) com uma JANELA em forma de raio vazada na
// face da frente — deixa o cabo CAT5 visível passando por dentro, mesma filosofia
// de "fiação exposta" já usada na base aberta do Arduino (pedido do Gabriel pra
// visitante ver como é feito). Serve também de elemento visual pra chamar atenção
// na bancada, junto com o próprio "Teste seu Reflexo" do tema.
//
// *** ATENÇÃO — MEDIDA NÃO CONFIRMADA ***
// Não achei em nenhum fornecedor (NeoDiver, Adafruit, outros) o diâmetro exato do furo
// de instalação desse botão de 100mm — os catálogos só dão o diâmetro da tampa (100mm),
// não o furo do painel. button_hole_d abaixo é uma ESTIMATIVA.
// -> Imprimir primeiro só o módulo `anel_teste()` (rápido, pouco filamento) e encaixar
//    o botão de verdade nele antes de imprimir o pedestal inteiro.

button_hole_d  = 96;   // ESTIMATIVA — ajustar depois de testar com o botão real
wall_t         = 4;
pedestal_h     = 60;   // altura do pedestal até o topo — ajustar quando medir a bancada
wire_channel_d = 10;   // canal central pro cabo CAT5 (8 fios cabem tranquilo em 10mm)

base_plate_h = 6;
hole_d       = 3.2;    // furo M3 pra fixar o pedestal na bancada

// --- Corpo hexagonal: dimensionado pra sobrar parede de verdade mesmo no centro
// de cada face (não só nas quinas) ---
inner_r     = button_hole_d / 2;
apothem     = inner_r + wall_t;                 // distância mínima centro->face
hex_d       = apothem * 2 / cos(30);            // diâmetro entre vértices (circunscrito)
apothem_real = hex_d / 2 * cos(30);

base_plate_d = hex_d + 24;                      // base mais larga que o corpo, pra estabilidade
hole_r_pos   = base_plate_d / 2 - 10;

// --- Janela em forma de raio, vazada na face da frente ---
bolt_w = min(apothem_real * 0.7, 36);           // largura do raio (não passa da face) — aumentada
bolt_h = pedestal_h * 0.7;                      // altura do raio — aumentada

$fn = 80;

module hex_prism(d, h) {
    // rotaciona 30° pra ficar com uma FACE (não uma quina) voltada pro eixo +X
    rotate([0, 0, 30])
        cylinder(d = d, h = h, $fn = 6);
}

// Silhueta clássica de raio (ícone padrão de "bolt"), organizada como
// [altura, largura] (mapeia certo depois da rotação em janela_raio())
module raio_2d(w, h) {
    hh = h / 2;
    polygon(points = [
        [ 1.0*hh,  0.1*w],
        [-0.2*hh, -0.9*w],
        [-0.2*hh,  0.0*w],
        [-1.0*hh, -0.1*w],
        [ 0.2*hh,  0.9*w],
        [ 0.2*hh,  0.0*w],
    ]);
}

module janela_raio() {
    depth = (apothem_real - inner_r) + 4;
    translate([inner_r - 2, 0, base_plate_h + pedestal_h/2])
        rotate([0, 90, 0])
            linear_extrude(height = depth)
                raio_2d(bolt_w, bolt_h);
}

module pedestal() {
    union() {
        // base larga, fixada na bancada
        difference() {
            cylinder(d = base_plate_d, h = base_plate_h);
            translate([0, 0, -1])
                cylinder(d = wire_channel_d, h = base_plate_h + 2);
            for (a = [0, 120, 240])
                rotate([0, 0, a])
                    translate([hole_r_pos, 0, -1])
                        cylinder(d = hole_d, h = base_plate_h + 2);
        }

        // corpo hexagonal do pedestal, com furo do botão no topo e janela do raio na frente
        translate([0, 0, base_plate_h])
            difference() {
                hex_prism(hex_d, pedestal_h);
                translate([0, 0, -1])
                    cylinder(d = button_hole_d, h = pedestal_h + 2);
                janela_raio();
            }
    }
}

// Peça de teste rápida — só um anel fino na altura do furo estimado,
// pra encaixar o botão real e confirmar a medida antes de imprimir o pedestal inteiro.
module anel_teste() {
    difference() {
        cylinder(d = button_hole_d + 2*wall_t, h = 8);
        translate([0, 0, -1])
            cylinder(d = button_hole_d, h = 10);
    }
}

// Descomentar uma linha por vez:
anel_teste();
// pedestal();
