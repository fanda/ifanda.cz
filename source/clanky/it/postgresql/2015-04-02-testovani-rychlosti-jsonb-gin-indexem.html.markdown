---
title: Testování rychlosti JSONB s GIN indexem
date: 2015-04-02 22:34
layout: article
comments: true
tags: [it, postgresql]
geshifilter: true
published: false
---

Open Source systém pro řízení báze dat PostgreSQL od verze 9.4 podporuje datový typ JSONB, který slouží pro ukládání JSON dokumentů v binární formě. Vyzkoušel jsem s tímto novým datovým typem několik dotazů - jednak rychlost importu dat z CSV souboru pomocí COPY a jednak několik méně či více složitých SELECT dotazů se zapnutým GIN indexem.

SPLIT

JSONB doplňuje datový typ JSON přidaný dříve, přičemž od JSON liší tím, že dokument restrukturuje a upraví. Zatímco JSON je z určitého pohledu jen obyčejný textový datový typ, který se musí při každé úpravě přeparsovat, JSONB neukládá žádné duplicitní klíče, maže nepotřebné bílé znaky (což neznamená, že zabírá méně místa!) a vylepšuje podporu indexování technikou GIN (Generalized Inverted Index).
