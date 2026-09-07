// Pedestal do botão de 100mm (jogador 1 ou 2) — furo no topo pro botão arcade,
// canal interno pra passar o cabo CAT5 até a base do jogo.
//
// *** ATENÇÃO — MEDIDA NÃO CONFIRMADA ***
// Não achei em nenhum fornecedor (NeoDiver, Adafruit, outros) o diâmetro exato do furo
// de instalação desse botão de 100mm — os catálogos só dão o diâmetro da tampa (100mm),
// não o furo do painel. button_hole_d abaixo é uma ESTIMATIVA.
// -> Imprimir primeiro só o módulo `anel_teste()` (rápido, pouco filamento) e encaixar
//    o botão de verdade nele antes de imprimir o pedestal inteiro.

button_hole_d = 96;   // ESTIMATIVA — ajustar depois de testar com o botão real
wall_t        = 4;
pedestal_h    = 60;   // altura do pedestal até o topo — ajustar quando medir a bancada
wire_channel_d = 10;  // canal central pro cabo CAT5 (8 fios cabem tranquilo em 10mm)

base_plate_d  = button_hole_d + 2*wall_t + 30;  // base mais larga que o topo, pra estabilidade
base_plate_h  = 6;
hole_d        = 3.2;  // furo M3 pra fixar o pedestal na bancada
hole_r_pos    = base_plate_d/2 - 10;

$fn = 80;

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

        // corpo do pedestal (tubo), com furo do botão no topo
        translate([0, 0, base_plate_h])
            difference() {
                cylinder(d = button_hole_d + 2*wall_t, h = pedestal_h);
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
