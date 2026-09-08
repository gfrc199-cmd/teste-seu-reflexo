// Objeto decorativo "Átomo" — núcleo + 3 órbitas inclinadas, símbolo universal de
// energia/eletricidade. Peça independente pra ficar em pé na bancada (não é parte
// funcional do jogo/contador — é só um enfeite/sinalizador visual do tema).
//
// Construído só com formas primitivas (esfera + toro via rotate_extrude) — sem
// polígono desenhado à mão, então sem risco do bug de autointersecção que pegamos
// nos ícones anteriores (raio, resistor).
//
// As 3 órbitas NÃO tocariam o núcleo sozinhas (o raio da órbita é bem maior que o
// núcleo) — por isso tem uma haste fina ligando o núcleo a cada órbita, senão a
// peça sairia em pedaços soltos, impossível de imprimir/segurar como peça única.
//
// *** RECOMENDADO ativar suporte no fatiador (Bambu Studio) *** — as órbitas
// inclinadas têm trechos em balanço que imprimem melhor com suporte.

nucleus_r = 9;     // raio do núcleo central
ring_R    = 28;    // raio da órbita (centro do eixo até o centro do tubo)
ring_r    = 2.2;   // raio do tubo do anel (~4,4mm de espessura)
tilt      = 60;    // inclinação de cada órbita em relação ao plano horizontal

base_d = 74;       // diâmetro da base
base_h = 5;        // altura da base

$fn = 64;

// levanta o conjunto núcleo+órbitas até o ponto mais baixo delas ficar embutido
// ~3mm dentro da base — garante fusão sólida (não só um ponto de contato tangente)
lift = (ring_R + ring_r) * sin(tilt) + ring_r + 2;

module torus(R, r) {
    rotate_extrude()
        translate([R, 0])
            circle(r = r);
}

module orbita(angle_z) {
    rotate([0, 0, angle_z])
        rotate([tilt, 0, 0])
            torus(ring_R, ring_r);
}

// haste que liga o núcleo a um ponto real da órbita (mesmo ângulo de rotação,
// calculado pra cair exatamente sobre o tubo do anel correspondente)
module haste(angle_z) {
    p = [ring_R * cos(angle_z), ring_R * sin(angle_z), 0];
    hull() {
        sphere(r = nucleus_r * 0.5);
        translate(p) sphere(r = ring_r);
    }
}

module atomo() {
    translate([0, 0, lift]) {
        sphere(r = nucleus_r);
        for (a = [0, 60, 120]) {
            orbita(a);
            haste(a);
        }
    }
}

module base() {
    cylinder(d = base_d, h = base_h);
}

union() {
    base();
    atomo();
}
