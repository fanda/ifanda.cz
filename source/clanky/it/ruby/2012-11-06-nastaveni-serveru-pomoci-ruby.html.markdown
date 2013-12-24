---
title: Nastavení serveru pomocí Ruby
date: 2012-11-06
comments: true
layout: article
tags: [it, ruby]
geshifilter: true
---

Pro svůj nový projekt jsem potřeboval instalační skript *na server*, respektive na počáteční nastavení serveru. Ten se spouští pouze jednou po instalaci operačního systému, a další správa systému probíhá přes webové rozhraní.


Osvědčená řešení, jako jsou programy [Puppet](http://puppetlabs.com/) nebo [Chef](http://www.opscode.com/chef/), jsem zavrhl po nějakém čase, kdy jsem si s nimi hrál. Tedy Chefa jsem si původně nechal rozmluvit sítí (hledal jsem: Puppet vs Chef) a později stejně udělal demo, které mě utvrdilo v původním rozhodnutí. Puppet je mnohem příjemnější než Chef, ale až potom, co si člověk zvykne na deklarativní styl jeho DSL. Puppet DSL a jeho špatně zdokumentovaná Ruby verze se ukázaly jako nevhodné pro jednorázovou operaci a nepřišel jsem na to, jak následně měnit nastavení v Ruby aplikaci.


Jeden nástroj, který splňuje všechny mé požadavky, existuje. Ruby gem [AutomateIt](http://automateit.org) je open source nástroj pro automatizaci a správu serverů, aplikací a jejich závislostí. Vývoj se u něj sice trochu zastavil, ale to co umí, dělá dobře. A umí toho docela dost.

Namodelován je tak, že se skládá z několika *Managerů*, interpreteru a třídy pro zapouzdření projektů, které se skládají z *receptů, tagů, polí a přídavků*. Toto jsou existující manageři:

* [AccountManager](http://automateit.org/documentation/classes/AutomateIt/AccountManager.html) - spravuje uživatele a skupiny
* [AddressManager](http://automateit.org/documentation/classes/AutomateIt/AddressManager.html) - stará se o sítové adresy
* [DownloadManager](http://automateit.org/documentation/classes/AutomateIt/DownloadManager.html) - stahuje soubory
* [EditManager](http://automateit.org/documentation/classes/AutomateIt/EditManager.html) - má příkazy pro editaci souborů
* [FieldManager](http://automateit.org/documentation/classes/AutomateIt/FieldManager.html) - čte konfigurační proměnné
* [PackageManager](http://automateit.org/documentation/classes/AutomateIt/PackageManager.html) - stará se o softwarové balíčky
* [PlatformManager](http://automateit.org/documentation/classes/AutomateIt/PlatformManager.html) - zjišťuje platformu a verzi OS
* [ServiceManage](http://automateit.org/documentation/classes/AutomateIt/ServiceManage.html) - Spravuje služby, např. OS démony
* [ShellManager](http://automateit.org/documentation/classes/AutomateIt/ShellManager.html) - spravuje soubory a provádí příkazy
* [TagManager](http://automateit.org/documentation/classes/AutomateIt/TagManager.html) - Seskupuje spravované počítače do skupin
* [TemplateManager](http://automateit.org/documentation/classes/AutomateIt/TemplateManager.html) - Tiskne šablony do souborů



