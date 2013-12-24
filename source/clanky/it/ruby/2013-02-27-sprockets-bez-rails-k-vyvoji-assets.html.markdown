---
title: Sprockets bez Rails
date: 2013-02-27 02:27
comments: true
layout: article
tags: [it, ruby]
geshifilter: true
---

Pro vývoj velmi výkonné webové aplikace v jazyce D, která je tvořena podle prototypu v [Ruby on Rails](http://rubyonrails.org/), jsem na internetu našel a specificky upravil krátky [Rack](http://rack.github.com/) skript, který vytvoří http server pro robustní klientské skriptování v [CoffeScriptu](http://coffeescript.org/). Lze využívat všechny výhody [Sprockets](https://github.com/sstephenson/sprockets) tak, jak je zvykem v Rails a při každém dotazu na soubory se [CoffeeScript](http://coffeescript.org/) i [Sass](http://sass-lang.com/) zkompilují.

Skript uložte s názvem <code>config.ru</code> a z jeho adresáře spouštějte příkazem <code>rackup</code>. Server poté naslouchá na portu 9292.
Je potřeba mít nainstalované **sprockets, rack, rack-mount** a asi i **sass, coffee-script** a možná ještě nějaké.

```bash
gem install sprockets rack rack-mount sass coffee-script
```

```ruby
require 'sprockets'
require 'rack'
require 'rack/mount'

project_root = File.expand_path(File.dirname(__FILE__))
Assets = Sprockets::Environment.new(File.dirname(__FILE__))

Assets.append_path(File.join(project_root, 'assets'))
Assets.append_path(File.join(project_root, 'assets', 'javascripts'))
Assets.append_path(File.join(project_root, 'assets', 'stylesheets'))

Routes = Rack::Mount::RouteSet.new do |set|
  set.add_route Assets, :path_info => %r{^/assets}

  map "/assets" do
    run Assets
  end
end

run Routes
```

Takto lze programovat [CoffeeScript](http://coffeescript.org/) a [Sass](http://sass-lang.com/) k serverové aplikaci v libovolném jazyce nebo frameworku
