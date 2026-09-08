// Base aberta pro Arduino Uno/Nano — fiação toda visível por cima (mesmo espírito da protoboard_tray)
// Não trava nos furos de parafuso do próprio Arduino: é uma bandeja com aba (lip),
// só segura a placa pelas bordas. Furos de fixação são pra prender a bandeja na bancada.
//
// Silhueta com CANTOS CHANFRADOS a 45° (octógono, não retângulo) — o "chamativo" vem
// da forma da peça em si, sem símbolo/ícone gravado.

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
wall_t     = 3;
floor_t    = 2;
lip_h      = 4;      // um pouco mais alto pra segurar o Arduino, que é mais pesado que a protoboard
hole_d     = 3.2;    // furo M3 pra fixar na bancada
hole_inset = 6;

chamfer = 9;          // tamanho do corte de 45° em cada canto

$fn = 40;

outer_l = pcb_l + 2*clearance + 2*wall_t;
outer_w = pcb_w + 2*clearance + 2*wall_t;
total_h = floor_t + lip_h;

module chamfered_prism(l, w, h, c) {
    linear_extrude(height = h)
        polygon(points = [
            [c, 0], [l - c, 0], [l, c], [l, w - c],
            [l - c, w], [c, w], [0, w - c], [0, c],
        ]);
}

module base() {
    difference() {
        chamfered_prism(outer_l, outer_w, total_h, chamfer);

        // bolsão interno onde o Arduino encaixa
        translate([wall_t, wall_t, floor_t])
            cube([pcb_l + 2*clearance, pcb_w + 2*clearance, lip_h + 1]);

        // rasgo pros conectores (USB + DC jack) numa parede curta
        translate([-1, wall_t, floor_t])
            cube([wall_t + conn_overhang + 1, pcb_w + 2*clearance, conn_h]);

        // furos de fixação nos 4 cantos (afastados o bastante do chanfro)
        for (x = [hole_inset, outer_l - hole_inset])
            for (y = [hole_inset, outer_w - hole_inset])
                translate([x, y, -1])
                    cylinder(d = hole_d, h = total_h + 2);
    }
}

base();

// NÃO TESTADO — assim como a protoboard_tray, imprimir 1 peça de teste antes de confirmar
// que o Arduino encaixa (folga de componentes embaixo da placa: cristal, leds, headers).
