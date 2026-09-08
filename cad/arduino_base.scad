// Base aberta pro Arduino Uno/Nano — fiação toda visível por cima (mesmo espírito da protoboard_tray)
// Não trava nos furos de parafuso do próprio Arduino: é uma bandeja com aba (lip),
// só segura a placa pelas bordas. Furos de fixação são pra prender a bandeja na bancada.

// --- Parametros do Arduino Uno R3 ---
pcb_l = 68.6;
pcb_w = 53.4;

// Conectores (USB + jack de energia) ficam na mesma ponta curta (largura), avançando um pouco
// pra fora da borda da placa — corte generoso, não precisa ser milimetricamente exato porque
// tudo fica exposto/visível de qualquer forma.
conn_overhang = 4;   // quanto o conector avança além da borda do PCB
conn_h        = 14;  // altura livre do rasgo (cobre USB + jack de uma vez)

// --- Parametros da bandeja (iguais à protoboard_tray pra manter o mesmo visual) ---
clearance  = 0.6;   // folga um pouco maior que a protoboard (Arduino tem componentes salientes embaixo)
wall_t     = 2;
floor_t    = 2;
lip_h      = 4;      // um pouco mais alto pra segurar o Arduino, que é mais pesado que a protoboard
hole_d     = 3.2;    // furo M3 pra fixar na bancada
hole_inset = 6;

// --- Selo gravado (símbolo de resistor) na parede da frente (Y=0), a que não tem
// corte de conector — gravação RASA (baixo-relevo), não vaza a parede de 2mm ---
engrave_depth = 1.0;   // raso — sobra 1mm de parede sólida atrás
res_line_r    = 0.9;   // espessura da linha do símbolo

$fn = 40;

outer_l = pcb_l + 2*clearance + 2*wall_t;
outer_w = pcb_w + 2*clearance + 2*wall_t;
total_h = floor_t + lip_h;

res_w = outer_l * 0.55;
res_h = total_h * 0.6;

// pontos do símbolo clássico de resistor (zigue-zague), normalizados em res_w x res_h
function res_pts() = [
    [0.00*res_w,  0.0*res_h],
    [0.14*res_w,  0.0*res_h],
    [0.24*res_w,  0.5*res_h],
    [0.38*res_w, -0.5*res_h],
    [0.52*res_w,  0.5*res_h],
    [0.66*res_w, -0.5*res_h],
    [0.80*res_w,  0.5*res_h],
    [0.90*res_w,  0.0*res_h],
    [1.00*res_w,  0.0*res_h],
];

// desenha uma linha grossa em 2D como corrente de cápsulas (hull de círculos) —
// evita polígono autointersectante (problema que já pegamos no raio do pedestal)
module linha_grossa_2d(pts, r) {
    for (i = [0 : len(pts) - 2])
        hull() {
            translate(pts[i]) circle(r = r, $fn = 16);
            translate(pts[i + 1]) circle(r = r, $fn = 16);
        }
}

module selo_resistor() {
    translate([(outer_l - res_w) / 2, -0.1, total_h / 2])
        rotate([-90, 0, 0])
            linear_extrude(height = engrave_depth + 0.1)
                linha_grossa_2d(res_pts(), res_line_r);
}

module base() {
    difference() {
        cube([outer_l, outer_w, total_h]);

        // bolsão interno onde o Arduino encaixa
        translate([wall_t, wall_t, floor_t])
            cube([pcb_l + 2*clearance, pcb_w + 2*clearance, lip_h + 1]);

        // rasgo pros conectores (USB + DC jack) numa parede curta
        translate([-1, wall_t, floor_t])
            cube([wall_t + conn_overhang + 1, pcb_w + 2*clearance, conn_h]);

        // furos de fixação nos 4 cantos
        for (x = [hole_inset, outer_l - hole_inset])
            for (y = [hole_inset, outer_w - hole_inset])
                translate([x, y, -1])
                    cylinder(d = hole_d, h = total_h + 2);

        // selo gravado do resistor, na parede de fora (Y=0)
        selo_resistor();
    }
}

base();

// NÃO TESTADO — assim como a protoboard_tray, imprimir 1 peça de teste antes de confirmar
// que o Arduino encaixa (folga de componentes embaixo da placa: cristal, leds, headers).
