---
title: Hliník
tags: [hliník, al, aluminium, eloxování, anodizing]
math: true
---

## Eloxování hliníku (aluminium anodizing)

* [Eloxování hliníku, Miloš Hroch](http://www.astronom.cz/procyon/chemistry/elox.html)
* [GALVANOVNA DOMA, Eloxování hliníku doma, ukázka návod Small Aluminium Anodising, PRVNÍ DÍL](https://www.youtube.com/watch?v=9OlfNybD6As)
* [GALVANOVNA DOMA, Eloxování hliníku doma, ukázka návod, DIY Anodized platig. DRUHÝ DÍL](https://www.youtube.com/watch?v=uBDK7WpW--A)
* [Small Scale Aluminium Anodising in the Home Workshop](https://www.youtube.com/watch?v=L2RKze7baJw)

### Materiál

* Hydroxid sodný (sodium hydroxide, NaOH, louh) - 20%
* Kyselina sírová (sulfuric acid, H2SO4) - 15-20%
* Destilovaná voda
* Jedlá soda (sodium bicarbonate, NaHCO3)

nebo

<https://www.funchem.cz/www-funchem-cz/eshop/14-1-POVRCHOVE-UPRAVY-KOVU/83-2-ELOXOVANI-HLINIKU>

### 720 Rule - výpočet

[Online kalulátor](https://caswellplating.com/720.html)

#### Konstanty

- thickness = 1 mil
- current density = 6A/ft2
- 1 mm^2 = 1.07639104 × 10^-5 ft2

#### Rovnice

$$t(min) = 720 * mils / CD$$

$$I(A) = CD*ft^2$$

#### Vzorový výpočet pro hranol 10x20x30mm

$$2*(10*20+10*30+20*30) = 2*(200+300+600) = 2*1100 = 2200mm^2 (= 0,021m^2)$$

$$2200mm^2 * 1,07639104 * 10^-5 = 0,02368 ft2$$

$$720 * 1 / 6 = 120 minut$$

$$0,02368 ft2 * 6A = 0,14208A$$

### Rule 312

* Rule of 720: Minutes to anodize = (mils (of coating desired) x 720) / amps per square foot (current density)
* Rule of 312: Minutes to anodize = (microns (of coating desired) x 3.12) / amps per square decimeter (current density)  
  source: <https://finishingandcoating.com/index.php/anodizing/1729-anodizing-by-current-density-vs-voltage>

### Postup

1. Důkladné očištění a odmaštění - aceton, alkohol, ultrazvuková čistička
2. Moření v louhu (etching) - 20 sekund
3. Opláchnutí
4. (Vyjasnění)
5. Opláchnutí
6. Anodizace v kyselině sírové
7. Opláchnutí / neutralizace v sodě
8. Barvení
9. Uzavření povrchu (sealing)
