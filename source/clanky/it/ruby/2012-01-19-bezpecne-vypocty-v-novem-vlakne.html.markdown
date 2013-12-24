---
title: Bezpečné výpočty v novém vlákně
date: 2012-01-19
comments: true
layout: article
tags: [it, ruby]
geshifilter: true
description: Bezpečnostní úrovně programů v Ruby a jejich použití v nově spuštěném vlákně. Použití ve frameworku Ruby on Rails.
---

Při tvorbě webové aplikace jsem řešil problém, jak uživateli poskytnout možnost zadat své vlastní matematické vzorce, které by se dále v programu prováděly a to tak, aby jejich běh neohrožoval bezpečnost celé webové aplikace či dokonce aplikačního serveru. Vlastní parser vzorců se mi vytvářet nechtěl; určitě by nebyl tak efektivní jako těch pár řádků kódu, kterými jsem problém vyřešil.


V programovacím jazyce Ruby lze nastavit bezpečnostní mód běhu a to naprosto jednoduše přiřazením čísla do proměnné $SAFE. Definováno je pět bezpečnostních úrovní:

|        |                                                             |
|:------:|:----------------------------------------------------------- |
| 0      |  Bez jakýchkoliv kontrol. Výchozí.                          |
| &gt;=1 |  Vyloučeny potenciálně nebezpečné operace.                  |
| &gt;=2 |  Zákaz načítání programových souborů z globálních umístění. |
| &gt;=3 |  Všechny nové objekty jsou podezřelé.                       |
| &gt;=4 |  Oddělení běhu programu, bezpečné objekty nelze měnit.      |

Zde je anglicky [podrobnější definice bezpečnostních úrovní](http://www.rubycentral.com/pickaxe/taint.html).

V mém řešení je v novém vlákně nastavena bezpečnostní úroveň číslo 4, tedy nejbezpečnější úroveň běhu. V této úrovni nelze použít ani puts. Matematický vzorec je uživatelem zadán jako řetězec a vyhodnotí se funkcí eval. Veškerý kód je krátký a srozumitelný:



```ruby
expr = "1*25+19/1"
begin
  result = Thread.start {$SAFE=4; eval(expr) }.value
rescue
  result = nil # pripadna chyba osetrena
end
```


Lze uživateli vytvořit efektivnější webovou kalkulačku?
