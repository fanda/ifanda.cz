---
title: Android aplikace v Ruby s Ruboto na Ubuntu
date: 2013-03-11 11:04
updated: 2013-04-02
comments: true
tags: [it, ruby]
geshifilter: true
---

Úvod do tvorby aplikací pro Android v jazyce Ruby pomocí gemu Ruboto, včetně popisu instalace Android SDK na Ubuntu.

Poslední změna 7. dubna 2013.
SPLIT

Příprava vývojového prostředí
-----------------------------

Obvykle se jako vývojová prostředí používají monumentální IDE, jako například Eclipse nebo možná Visual Studio, ale vše by mělo jít přímo z příkazové řádky. Jestli všechno funguje správně, se dozvíte, až to zkusíte. Potřebujete dobré internetové připojení, protože vývojové prostředí pro Android je poměrně velký balík dat.

Následující postup je vytvořen podle wiki stránek Ruboto a byl vyzkoušen na čisté instalaci Ubuntu 12.04 ve VirtualBoxu.

Nejdříve je potřeba získat všechny balíčky. Vyžadována je Java, Ant a Ruby. Ruby má více implementací, přičemž Ruboto by mělo fungovat s MRI i s JRuby. Zde sice pro vývoj používám MRI, ale i tak se JRuby použije - jako interpret aplikace na Androidu.

```bash
sudo apt-get install default-jdk ant ruby rubygems rake
```

Pokud používáte 64-bitový systém, tak nainstalujte ještě balíček *ia32-libs*.

Po instalaci balíčků je potřeba nainstalovat Android SDK. Je výhodné instalovat do adresáře, kam má přihlášený uživatel přístup, protože se tím usnadní spouštění emulátoru a všech SDK utilit. Zjistěte si, jaká je nejnovější verze SDK a vyplňte podle toho ANDROID_REVISION. Po zadání všech dalších příkazů by mělo být vývojové prostředí pro Android nainstalované.

```bash
ANDROID_REVISION=21.1
ANDROID_LOCATION=~

cd $ANDROID_LOCATION
wget http://dl.google.com/android/android-sdk_r$ANDROID_REVISION-linux.tgz
tar --no-same-owner -xzvf android-sdk_r$ANDROID_REVISION-linux.tgz
chmod -R a+xr android-sdk-linux
rm android-sdk_r$ANDROID_REVISION-linux.tgz
$ANDROID_LOCATION/android-sdk-linux/tools/android update sdk -u -t platform-tool
$ANDROID_LOCATION/android-sdk-linux/tools/android update sdk -u -t platform
```

Po instalaci chceme, aby bylo vývojové prostředí připraveno pro použití ihned po startu systému. V souboru **.bashrc** nastavíme proměné a cesty pro spouštění SDK utilit.

```bash
echo -e "\n##############################################\n#\n# PATH Additions\n#\n\n"  >> .bashrc
echo "ANDROID_HOME=$ANDROID_LOCATION/android-sdk-linux" >> .bashrc
echo "RUBY_GEM_HOME=/var/lib/gems/1.8" >> .bashrc
echo -e "PATH=$""PATH:$""ANDROID_HOME/tools:$""ANDROID_HOME/platform-tools:$""RUBY_GEM_HOME/bin\n" \
 >> .bashrc
source .bashrc
```
Bez problému by nyní měl jít spustit program <code>android</code>, který - když se zavolá bez parametrů - zobrazí SDK Manager, kde se instalují jednotlivé verze androidího API. Nainstalujte si libovolné API. Když poté spustíte <code>android list targets</code>, získáte seznam možných cílů emulace.

Vyberte si nějaký *target* a vytvořte Android Virtual Devise, tedy specifikaci platformy pro emulátor. Při vytváření AVD jsou povinné dva parametry: název (-n) a target (-t). Název si zvolíte a target vyberete ze seznamu (lze zadat id i slovní název). Název se zadává při spouštění emulátoru.

```bash
android -s create avd -f -n A_4.1 -t 1 --sdcard 64M
emulator -avd A_4.1
```

Nyní by mělo být vidět okno emulátoru, což znamená, že instalace Android SDK byla úspěšná. Není to ale poslední krok instalace celého prostředí pro vývoj androidích aplikací v Ruby. Nakonec potřebujeme rubygem Ruboto. Včetně závislostí se dá jednoduše nainstalovat příkazem gem.

```bash
sudo gem install ruboto
```

Prostředí pro vývoj aplikací pro platformu Android by v tomto bodě mělo být připraveno.

### Poznámka ke spouštění Ruboto na Androidu

Ruby skript je na androidu spuštěn pomocí interpretu JRuby a existují dvě možnosti, jak jej do emulátoru nebo na zařízení dostat.

1. Při prvním spuštění aplikace se zobrazí výzva k instalaci aplikace Ruboto Core. Po instalaci je Ruboto Core k dispozici všem Ruboto aplikacím, ale v nabídce zůstane neužitečná ikonka, protože aplikace jinak nic nedělá.
2. Přiložení JRuby přímo k aplikaci, což vyžaduje gem *jruby-jars* a zvětší výslednou aplikaci asi o deset megabytů.



Vytvoření první Android aplikace s Ruboto
-----------------------------------

Ruboto přidává k dobru vlastní utility, mimo jiné generátory, které na rozdíl od člověka nezapomínají vkládat důležité proměnné do kdejakých manifestů. Následující příkazy ukazují první použití generátorů. První příkaz vygeneruje poměrně složitou adresářovou strukturu aplikace; druhý příkaz generuje aktivitu.

```bash
ruboto gen app --package cz.rubyn.mt --target=android-8
ruboto gen class Activity --name AwesomeActivity
```

Aktivity v Ruby jsou z principu velmi podobné těm v Java. Pro inspiraci a naladění si prohlížím [testovací aktivity](https://github.com/ruboto/ruboto/tree/master/test/activity) nebo systematicky popsané [příklady použití](https://github.com/ruboto/ruboto/wiki/Tutorials-and-examples).

Moje první funkční aktivita, která pomocí knihovny <code>net/http</code> stahovala JSON ze serveru, vypadala podobně jako ta následující.

```ruby
require 'ruboto/widget'
require 'ruboto/util/toast'
require 'ruboto/util/stack'

with_large_stack(:size => 256) {
  require 'ostruct'
  require 'net/http'
  require 'json/pure'
}

#import "android.net.Uri"
#import "android.net.AndroidHttpClient"

ruboto_import_widgets :LinearLayout, :TextView

class AwesomeActivity
  include Net

  def on_create(bundle)
    setTitle 'Rubyn MT'
    @srv = HTTP.new("example.net", 80)
    response = @srv.request( HTTP::Get.new( "/my.json" ) )
    raw = response.body.to_s

    self.content_view = linear_layout :orientation => :vertical do
      text_view :text => 'RAW'
      text_view :text => raw.to_s
      text_view :text => 'RUBY'
      text_view :text => json2ruby(raw).inspect
    end
  end
private
  def json2ruby(json)
    JSON.load json
  rescue Exception
    toast($!.message)
  end
end
```

Ruboto je náročnější na paměť, takže než jsem přidal volání <code>with\_large\_stack</code>, tak skript končil s výjimkou StackOverflowError.

Vytvořit HTTP request lze i přes Android SDK, pomocí AndroidHttpClient. Vlastně je možno naimportovat jakoukoliv třídu z SDK. V kódu předešlé aktivity to ukazují zakomentované řádky.

Navigace do druhé nové aktivity
-------------------------------

Další praktickou ukázkou programování aplikace pro Android pomocí Ruboto je předání dat a start nové aktivity. V následujícím kódu se při kliknutí na tlačítko přejde společně s nějakými daty do druhé aktivity, která při další akci předá jiná data zpět volající aktivitě. Také zde lze pozorovat, jaké důsledky má použití příkazu import.

```ruby
import "android.content.Intent"
# import "android.os.Bundle"
class AwesomeActivity
  # ...
  def on_create(bundle)
    self.content_view = linear_layout :orientation => :vertical do
      button :text => 'Bum',
        :on_click_listener => proc{show_second_activity}
    end
  end
  def show_second_activity
    # access Android SDK without import
    bundle = android.os.Bundle.new
    bundle.put_string('ClassName', 'SecondActivity')
    # access Android SDK with import
    i = Intent.new # also: i = android.content.Intent.new
    i.setClassName($package_name, 'org.ruboto.RubotoActivity')
    i.putExtra('Ruboto Config', bundle)
    i.putExtra('My String', 'I\'m Android Ruboto')
    startActivityForResult(i, 1)
  end
  def on_activity_result(request, result, i)
    super(request, result, i)
    new_content = i.getStringExtra('Result String')
    # ...
  end
end

class SecondActivity
  def on_create(bundle)
    super
    bundle = getIntent().getExtras()
    button :text => bundle.getString('My String'),
        :on_click_listener => proc{submit('Submit')}
    end
  end
  def submit(msg)
    i = Intent.new
    i.putExtra('Result String', msg )
    setResult(RESULT_OK, i)
    finish
  end
end
```

Další možnosti navigace do druhých aktivit pomocí Ruboto lze najít v jednom [zdrojovém kódu na github.com](https://github.com/ruboto/ruboto/blob/master/test/activity/navigation_activity.rb).

Nejsprávnější způson pro vytváření nových aktivit je pomocí Ruboto generátoru.

```bash
ruboto gen class Activity --name SecondActivity
```

Ovšem v nově vygenerovaném skriptu <code>src/second\_activity.rb</code> lze vytvořit libovolný počet dalších aktivit. Příkladem je předcházející kód se dvěma aktivitami nebo také kód ve výše odkazovaném souboru.


Hodnocení práce s Ruboto
------------------------

Android je bezesporu a v mnoha ohledech zajímavá platforma a Ruboto našlo elegantní způsob, jak na ní programovat v Ruby, ale má to i nevýhody. Velmi oceňuji generátory a Rake příkazy, avšak na druhou stranu kompilace a spouštění na emulátoru se trochu protáhnou, takže se vývoj prodlužuje. K výsledné aplikace je vždy potřeba interpret jazyka Ruby, a jak už to u skriptovacích jazyků bývá, aplikace je náročnější na operační paměť. Ne jednou jsem při vývoji řešil StackOverflowError, tedy přetečení zásobníku.

Ani všechny nevýhody ovšem nemohou převážit hlavní výhodu: díky Ruboto můžeme pro Android programovat v Ruby a ne jen v Java.


Odkazy
------

* [Motivační prezentace](http://www.slideshare.net/adamblum/using-ruby-in-android-development)
* [Ruboto Wiki](https://github.com/ruboto/ruboto/wiki); informace z první ruky
* [Ruboto Slajdy](http://robdimarco.github.io/redsnake-2013-ruboto-presentation); Ruboto v kostce
* [Velmi informativní článek](http://www.ibm.com/developerworks/library/wa-ruby/)
* [Další informativní článek](http://withincc.blogspot.cz/2012_04_01_archive.html)
