// Bandeja aberta pra protoboard 830 pontos — peça de teste
// Base aberta = Arduino ja tem modelo pronto (Cults3D); esta peça complementa
// segurando o protoboard ao lado, sem tampa, fiacao toda visivel por cima.
// Medidas de placa padrao "full-size" 830 pontos: 165 x 55 x 8.5mm

// --- Parametros do protoboard ---
pb_l = 165;
pb_w = 55;
pb_h = 8.5;

// --- Parametros da bandeja ---
clearance = 0.4;   // folga por lado pra encaixar sem forcar
wall_t    = 2;      // espessura da parede
floor_t   = 2;      // espessura do fundo
lip_h     = 3;       // altura da parede (segura so a base do protoboard, resto fica exposto)
slot_w    = 40;      // largura do rasgo pra saida dos fios, numa parede longa
hole_d    = 3.2;     // furo pra parafuso M3 (fixar na bancada)
hole_inset = 6;       // distancia do furo ate a quina

$fn = 40;

outer_l = pb_l + 2*clearance + 2*wall_t;
outer_w = pb_w + 2*clearance + 2*wall_t;
total_h = floor_t + lip_h;

module tray() {
    difference() {
        // bloco externo
        cube([outer_l, outer_w, total_h]);

        // bolsao interno onde o protoboard encaixa
        translate([wall_t, wall_t, floor_t])
            cube([pb_l + 2*clearance, pb_w + 2*clearance, lip_h + 1]);

        // rasgo pra fios saírem por uma parede longa (lado que fica de frente pro Arduino)
        translate([outer_l/2 - slot_w/2, -1, floor_t])
            cube([slot_w, wall_t + 2, lip_h + 1]);

        // furos de fixacao nos 4 cantos
        for (x = [hole_inset, outer_l - hole_inset])
            for (y = [hole_inset, outer_w - hole_inset])
                translate([x, y, -1])
                    cylinder(d = hole_d, h = total_h + 2);
    }
}

tray();
