---
title: Konfigurační soubor v Ruby on Rails
dat: 2012-03-08
comments: true
layout: article
tags: [it, ruby]
geshifilter: true
---

Při programování webových aplikací je často potřeba mít k dispozici hodnoty, které se za běhu aplikace nemění, konfigurační konstanty aplikace. Jak už to tak bývá, dají se v Ruby on Rails konstanty zadávat hned několika způsoby.

Já si vytvářím konfigurační soubor *config/config.yml* ve formátu YAML, kde mám konstanty navíc rozděleny na vývojové a produkční prostředí. Soubor má následující strukturu.

```ruby
development:
  locales: ['cz']
  currency: 'Kč'
  long_title: 'Eshop long title'
  short_title: Eshop short
  ga_id: xxx
production:
  locales: ['cz']
  currency: 'Kč'
  long_title: 'Eshop long title'
  short_title: Eshop short
  ga_id: xxx
```

Konfigurační soubor pak do Ruby on Rails aplikace načtu při jejím startu pomocí iniciačního souboru *config/initializers/app_config.rb*, ve kterém se vytvoří asociativní pole typu *OpenStruct* obsahující konfigurací, k níž pak přistupuji jakobych volal funkce třídy. Například **AppConfig.currency** (=> 'Kč'). Všimněte si, že nemusím zadávat, zda chci hodnoty pro vývojové nebo produkční prostředí.

```ruby
# Load application configuration
require 'ostruct'
require 'yaml'

config = YAML.load_file("#{Rails.root}/config/config.yml") || {}
app_config = config['common'] || {}
app_config.update(config[Rails.env] || {})
AppConfig = OpenStruct.new(app_config)
```

Výše uvedený kód (který volně koluje po Ruby on Rails fórech) má ovšem i své nedokonalosti. Pokud chci konfigurační soubor s vnořenými hodnotami, viz ukázka, nemohu získat hodnotu voláním **AppConfig.picture_style.large**, ale musím použít **AppConfig.picture_style['large']**. To se mi ale nelíbí.

```ruby
development:
  locales: ['cz']
  currency: 'Kč'
  long_title: 'Eshop long title'
  short_title: Eshop short
  ga_id: xxx
  picture_style:
    square: '150x150#'
    large: '280x280>'
    original: '840x840>'
production:
  locales: ['cz']
  currency: 'Kč'
  long_title: 'Eshop long title'
  short_title: Eshop short
  ga_id: xxx
  picture_style:
    square: '150x150#'
    large: '280x280>'
    original: '840x840>'
```

Aby se snadněji získávaly vnořené konfigurační hodnoty, musí se *OpenStruct* vytvořit v každém zanoření zvlášť. Iniciační soubor jsem si k tomu musel trochu přeprogramovat. Jeho základ nyní tvoří rekurzivní anonymní funkce, která projde konfigurační soubor a všude, kde je to možné, vytvoří asociativní pole typu *OpenStruct*.

```ruby
# Load application configuration
require 'ostruct'
require 'yaml'

config = YAML.load_file("#{Rails.root}/config/config.yml") || {}
app_config = config['common'] || {}
app_config.update(config[Rails.env] || {})
h2ostruct = lambda do | recurse, object |
  return case object
  when Hash
    object = object.clone
    object.each do |key, value|
      object[key] = recurse.call(recurse, value)
    end
    OpenStruct.new(object)
  when Array
    object = object.clone
    object.map! { |i| recurse.call(recurse, i) }
  else
    object
  end
end
AppConfig = h2ostruct[h2ostruct, app_config]
```

Vnořená konfigurace je nyní přístupnější a já jsem při programování šťastnější :)
