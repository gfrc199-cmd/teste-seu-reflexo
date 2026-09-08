// Pedestal do botão de 100mm (jogador 1 ou 2) — furo no topo pro botão arcade,
// canal interno pra passar o cabo CAT5 até a base do jogo.
//
// Corpo HEXAGONAL com o topo CHANFRADO (bisel de 45°, como uma porca sextavada) —
// forma vem da geometria em si (facetada), sem ícone/símbolo gravado.
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
inner_r      = button_hole_d / 2;
apothem      = inner_r + wall_t;                // distância mínima centro->face
hex_d        = apothem * 2 / cos(30);           // diâmetro entre vértices (circunscrito)
apothem_real = hex_d / 2 * cos(30);

base_plate_d = hex_d + 24;                      // base mais larga que o corpo, pra estabilidade
hole_r_pos   = base_plate_d / 2 - 10;

// --- Chanfros (45°) — é isso que dá o "formato", não gravação ---
bevel_top   = 8;   // altura do bisel no topo do corpo hexagonal
bevel_plate = 2.5; // altura do bisel na borda da base

$fn = 80;

module hex_prism(d, h) {
    // rotaciona 30° pra ficar com uma FACE (não uma quina) voltada pro eixo +X
    rotate([0, 0, 30])
        cylinder(d = d, h = h, $fn = 6);
}

// corpo hexagonal com o topo chanfrado a 45°: hull entre o hexágono cheio
// (até a altura h-bevel) e um hexágono menor rente ao topo
module hex_chanfrado(d, h, bevel) {
    shrink = 1 - bevel / apothem_real;   // reduz o diâmetro proporcionalmente ao apótema
    hull() {
        hex_prism(d, h - bevel);
        translate([0, 0, h - bevel])
            hex_prism(d * shrink, 0.01);
    }
}

// disco da base com a borda de cima chanfrada
module disco_chanfrado(d, h, bevel) {
    hull() {
        cylinder(d = d, h = h - bevel);
        translate([0, 0, h - bevel])
            cylinder(d = d - 2*bevel, h = 0.01);
    }
}

module pedestal() {
    union() {
        // base larga, fixada na bancada, com borda chanfrada
        difference() {
            disco_chanfrado(base_plate_d, base_plate_h, bevel_plate);
            translate([0, 0, -1])
                cylinder(d = wire_channel_d, h = base_plate_h + 2);
            for (a = [0, 120, 240])
                rotate([0, 0, a])
                    translate([hole_r_pos, 0, -1])
                        cylinder(d = hole_d, h = base_plate_h + 2);
        }

        // corpo hexagonal do pedestal, topo chanfrado, com furo do botão
        translate([0, 0, base_plate_h])
            difference() {
                hex_chanfrado(hex_d, pedestal_h, bevel_top);
                translate([0, 0, -1])
                    cylinder(d = button_hole_d, h = pedestal_h + 2);
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
