activate :blog do |blog|
  # set options on blog
#  blog.prefix = "clanky"
  blog.permalink = ":cat/:year-:month-:day-:title"
  blog.sources = "clanky/:cat/:year-:month-:day-:title"
  blog.summary_separator = /SPLIT/
  blog.paginate = true
  blog.page_link = "strana-:num"
  blog.per_page = 20
  blog.taglink = ":tag/index.html"
  blog.tag_template = "tag.html"
  blog.layout = 'layouts/article'
end

#page "/video/*", :layout => "video"

activate :directory_indexes
activate :livereload

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true, :tables => true
activate :syntax, :line_numbers => false #, :linenos => 'inline', :anchorlinenos => true

set :haml, { ugly: true }
set :erb, { ugly: true }

set :css_dir, 'a/cs'

set :js_dir, 'a/script'

set :images_dir, 'a/pix'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  # activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end
