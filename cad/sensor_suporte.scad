// Suporte pro sensor de obstáculo infravermelho (contador de visitantes) — prende no
// batente da porta, um de cada lado (S1 corredor, S2 sala). Mesma lógica de bandeja
// aberta das outras peças: segura o módulo pelas bordas, sem cobrir os LEDs/trimpot.
//
// *** MEDIDAS DO MÓDULO — PADRÃO GENÉRICO, NÃO CONFIRMADAS COM O SENSOR REAL ***
// board_l/board_w/hole_spacing são os valores típicos desse tipo de módulo de 3 pinos
// (o mesmo vendido na Eletrogate). Confirma com paquímetro quando o sensor chegar —
// se bater, é só reimprimir com o valor certo.

board_l        = 45.2;  // comprimento da placa (do conector até a ponta dos LEDs)
board_w        = 20.1;  // largura da placa
hole_spacing_l = 38;    // distância entre os 2 furos de fixação do próprio módulo (centro a centro, no sentido do comprimento)
board_hole_d   = 2.2;   // furo de fixação do módulo (parafuso pequeno, M2)

clearance = 0.5;
wall_t    = 3;         // engrossada de 2->3mm pra aguentar gravação mais funda e visível
floor_t   = 2;
lip_h     = 3;         // baixo o bastante pra não tampar o trimpot nem os LEDs

// furos pra fixar o suporte no batente da porta (parafuso maior, M3)
mount_hole_d = 3.2;
mount_inset  = 6;

// rasgo de saída do cabo (3 fios: VCC/GND/OUT, indo pro CAT5) na parede de trás
cable_slot_w = 12;
cable_slot_h = 6;

// --- Selo gravado (raio pequeno, mesmo símbolo do pedestal) na parede da ponta
// oposta ao rasgo do cabo — bem mais marcada que antes, ainda sem vazar (parede 3mm) ---
engrave_depth = 1.8;   // sobra 1,2mm sólido — bem mais funda que antes (era 0,7/2mm)

$fn = 40;

outer_l = board_l + 2*clearance + 2*wall_t;
outer_w = board_w + 2*clearance + 2*wall_t;
total_h = floor_t + lip_h;

bolt_w = outer_w * 0.55;
bolt_h = total_h * 0.85;

// mesmo polígono de raio já validado (sem autointersecção) usado no botao_pedestal.scad
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

module selo_raio() {
    translate([outer_l - engrave_depth, outer_w / 2, total_h / 2])
        rotate([0, 90, 0])
            linear_extrude(height = engrave_depth + 0.1)
                raio_2d(bolt_w, bolt_h);
}

module suporte() {
    difference() {
        cube([outer_l, outer_w, total_h]);

        // bolsão onde o módulo encaixa
        translate([wall_t, wall_t, floor_t])
            cube([board_l + 2*clearance, board_w + 2*clearance, lip_h + 1]);

        // rasgo pro cabo sair pela parede de trás (lado oposto aos LEDs/lente)
        translate([-1, outer_w/2 - cable_slot_w/2, floor_t])
            cube([wall_t + 2, cable_slot_w, cable_slot_h]);

        // furos de fixação do módulo em si (opcional — trava com parafuso M2 além da folga)
        // os 2 furos do módulo ficam espaçados ao longo do comprimento (eixo X), centrados na largura
        board_center_y = wall_t + clearance + board_w/2;
        translate([outer_l/2 - hole_spacing_l/2, board_center_y, -1])
            cylinder(d = board_hole_d, h = total_h + 2);
        translate([outer_l/2 + hole_spacing_l/2, board_center_y, -1])
            cylinder(d = board_hole_d, h = total_h + 2);

        // furos de fixação no batente da porta (2, nas pontas)
        translate([mount_inset, outer_w/2, -1])
            cylinder(d = mount_hole_d, h = total_h + 2);
        translate([outer_l - mount_inset, outer_w/2, -1])
            cylinder(d = mount_hole_d, h = total_h + 2);

        // selo gravado do raio, na parede da ponta oposta ao cabo (X=outer_l)
        selo_raio();
    }
}

suporte();

// NÃO TESTADO — imprimir 1 peça de teste e conferir encaixe com o sensor real antes
// de imprimir o par completo (S1 + S2).
