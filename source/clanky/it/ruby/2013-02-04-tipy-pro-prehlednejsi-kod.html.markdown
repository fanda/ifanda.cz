---
title: Tipy pro přehlednější kód v Ruby
date: 2013-02-04
comments: true
layout: article
tags: [it, ruby]
geshifilter: true
---

Jazyk Ruby dovoluje zapisovat víceméně ekvivalentní kód různými způsoby. Některé zápisy se dobře čtou, jiné jsou více efektivní a dají se vymyslet takové, co se dobře čtou a jsou i velmi efektivní (ať už paměťově nebo výkonnostně). Nebudu se pouštět do hlubokých rozborů následujících útržků kódu, pouze je nabízím jako inspiraci.

Podmíněná návratová hodnota
---------------------------

Jako první uvádím variace na ternární operátor pro podmínku, který zná téměř každý, kdo programuje v jazycích C/C++, php, JavaScript a v mnoha dalších. Jeho použití je v Ruby následující:

```ruby
def jedna!
    true ? :jedna : 'dvě' # => :jedna
end
```
Dle mého názoru se hodí spíše pro podmíněné přiřazení, než k podmínce o návratové hodnotě. Někteří programátoři jej nepoužívají vůbec. Sám musím uznat, že následující zápis je mnohem sebevysvětlující.

```ruby
def jedna_nebo_2(kolik)
    return :jedna if kolik == 1
    'dvě'
end
```
Jak zapsat tuto funkci pouze na jeden řádek? Hezké je to s použitím operátoru *or* takto:

```ruby
def jedna_nebo_2(kolik)
    (:jedna if kolik == 1) or 'dvě'
end
```
Tu nejdelší variantu na pět řádků s *if*, *else* a *end* zde uvádět nechci a myslím, že ani nemusím.


Testování hodnot v objektu
--------------------------

U podmínek ještě chvíli zůstaňme. Občas má program vykonat nějakou činnost, pokud je ekvivaletní jedné z několika různých hodnot.

```ruby
if kolik == :jedna or kolik == 'dvě' or kolik == 'tři' or kolik == 4 # případně dále
```
Taková podmínka může být i na několik řádků a přehledná rozhodně není. Mnohem lepší se mi v takových případech jeví dát hodnoty do pole a zavolat jeho metodu include?.

```ruby
if [:jedna, 'dvě', 'tři', 4].include?(kolik)
```
Kdyby se jednalo jen o slova (řetězce), mohl by se zápis psát lépe použitím %w().

```ruby
if %w(jedna dvě tři čtyři).include?(kolik)
```


Mnohonásobné přiřazení hodnot z Hash
------------------------------------

Představte si, že máte následující zanořený Hash a potřebujete z něj bezpečně získat hodnoty *name* a *nick*. Uvažme, že Hash jako celek nikdy nebude nil, ale vnořený Hash info být prázdný může.

```ruby
user = {
    id: 'xxx',
    info: {
        name: 'pan Poctivý',
        nick: 'pp'
    }
}
```
Ne zrovna hloupá, ale určitě pracná (pokud by hodnot bylo víc jak dvě) je tato:

```ruby
name = user[:info] and user[:info][:name]
nick = user[:info] and user[:info][:nick]
```
Kontrola user[:info] se dá samozřejmě dát do podmínky a pro více jak dvě přiřazované hodnoty je to určitě záhodno.

```ruby
if info = user[:info]
  name = info[:name]
  nick = info[:nick]
end
```
Přiřazení do proměnné info v podmínce, která kontroluje přítomnost zanořené struktury, zjednoduší zápis uvnitř bloku. Tento kus kódu v Ruby se ovšem dá zapsat na jednom jediném řádku. Objekt typu Hash má zajímavou metodu [values_at](http://www.ruby-doc.org/core-1.9.3/Hash.html#method-i-values_at), která vrací hodnoty, jejichž klíče jsou předány jako parametry. I s podmínkou se použije třeba takto:

```ruby
name, nick = user[:info].values_at(:name, :nick) if user[:info]
```
Asi by to stále nebylo to pravé ořechové, pokud by byly potřeba víc než dvě hodnoty, ale je to hezké a takové "Ruby".
