---
title: Správné nastavení SSL v Nginx
date: 2015-03-23 21:04
layout: article
comments: false
tags: [it, nginx]
geshifilter: true
---

Nginx [engin-x] je vysose výkoný webový server, který podporuje protokol SSL (Secure Sockets Layer) zajišťující šifrovanou komunikaci včetně vzájemné autentizace klienta a serveru. SSL je sice ve výchozí konfiguraci aktivní, ovšem toto nastavení není tak optimální, jak by mohlo být. Zde je návrh, jak konfiguraci SSL v Nginx zlepšit.

SPLIT

Nebudu chodit kolem horké kaše. Zde je celá zmíněná konfigurace.

```
http {
  ssl_prefer_server_ciphers on;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA !RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS";

  ssl_stapling on;
  ssl_stapling_verify on;
  ssl_trusted_certificate /etc/nginx/ssl/stapling_trusted.crt;
  resolver 8.8.4.4 8.8.8.8 valid=300s;
  resolver_timeout 10s;

  ssl_session_cache shared:SSL:32m;
  ssl_buffer_size 8k;
  ssl_session_timeout 10m;
}
```

Pro účely vysvětlení jsou direktivy uvnitř bloku *http* rozděleny volnými řádky na tři bloky.
V prvním bloku se definují povolené verze a zabezpečovací mechanizmy. Za zmínku zde stojí, že není povolené SSL verze 3, které je náchylné k tzv. [POODLE&nbsp;útoku](http://www.root.cz/clanky/poodle-utok-na-sslv3/). Pozor na to, že vypsané povolené a zakázané šifrovací mechanizmy nedají vzniknout spojení s prohlížeči IE6 a IE8 na Windows XP, ale to by dnes měla být naprosto zanedbatelná menšina.

Druhý blok je o něco zajímavější. Aktivuje tzv. <a href="http://en.wikipedia.org/wiki/OCSP_stapling">OCSP&nbsp;stapling</a>, což je mechanizmus pro ověřování správnosti SSL certifikátu, který dovoluje ověřovat certifikát podle podepsané časové známky, čímž snižuje počet dotazů na certifikační autoritu a tím pádem zvyšuje rychlost zabezpečené komunikace. Podle <a href="http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_stapling">Nginx dokumentace k ssl_stapling</a> je potřeba specifikovat DNS resolver, který přeloží jméno OCSP responderu. Google dává k dispozici své DNS servery s adresami 8.8.8.8 a 8.8.4.4, ale pokud preferujete vlastního DNS servery, tak resolver jednoduše upravte.

Ve třetím bloku se nastavuje velikost bufferu a především zapíná sdílená *SSL session cache*, která dává potenciál pamatovat si na 10 minut až 32 x [4000](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_session_cache) = 128000 zabezpečených spojení a tím zvýšit jejich rychlost.

Na závěr ještě jeden tip na zvýšení výkonu. Nginx dovoluje aktivovat <a href="http://www.techrepublic.com/article/take-advantage-of-tcp-ip-options-to-optimize-data-transmission/">TCP&nbsp;DEFER&nbsp;ACCEPT</a>, což urychlí navázání TCP spojení mezi klientem a serverem. Jednoduše k direktivě <em>listen</em> napište slovo <strong>deferred</strong>.

```
server {
  listen 443 deferred ssl;
}
```
