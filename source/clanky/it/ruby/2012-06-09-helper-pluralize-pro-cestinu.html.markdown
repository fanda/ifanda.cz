---
title: Helper pluralize pro češtinu
dat: 2012-03-08
comments: true
layout: article
tags: [it, ruby]
geshifilter: true
---

Pomocná metoda *pluralize* je skvělý pomocník pro výpis počtu položek jakéhokoliv druhu. Čestina je ovšem trochu složitější jazyk než angličtina a u skloňování číslovek nerozlišuje jen 1 a více (jako angličtina), ale také zda je položek 2, 3 nebo 4.

Příklad:<br/>
*0 položek<br/>
1 položka<br/>
2|3|4 položky<br/>
5 a více položek*

nebo<br/>
*0 koťat<br/>
1 kotě<br/>
2|3|4 koťata<br/>
5 a více koťat*

Abychom mohli metodu pluralize používat v českých aplikacích, je potřeba tuto metodu trochu přepsat. Následující kus kódu můžete rovnou přidat do aplikace.

```ruby
module ActionView
  module Helpers
    module TextHelper
      def pluralize(count, singular, plural = nil, even_more = nil)
          "#{count || 0} " + if count == 1 || count == '1'
           singular
         elsif plural
           if [2, 3, 4].include?(count.to_i)
             plural
           elsif even_more
             even_more
           else
             plural
           end
         elsif Object.const_defined?("Inflector")
           Inflector.pluralize(singular)
         else
           singular + "s"
         end
       end
    end
  end
end
```

Metoda se pak volá podobně jako její anglický protějšek a funguje pro čísla i řetězce číslic.

```ruby
pluralize(0, 'kotě', 'koťata', 'koťat')
pluralize(1, 'kotě', 'koťata', 'koťat')
pluralize('2', 'kotě', 'koťata', 'koťat')
pluralize('5', 'kotě', 'koťata', 'koťat')
```
