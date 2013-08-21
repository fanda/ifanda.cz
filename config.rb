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
activate :syntax, :linenos => 'inline', :anchorlinenos => true

set :markdown_engine, :redcarpet
set :markdown, :fenced_code_blocks => true, :smartypants => true, :tables => true

set :haml, { ugly: true }
set :erb, { ugly: true }

###
# Compass
###

# Susy grids in Compass
# First: gem install susy
# require 'susy'

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

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
