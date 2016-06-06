###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  def nav_resources
    sitemap.resources
      .select { |r| r.data.nav_order }
      .sort_by { |r| r.data.nav_order }
  end
end

# Build-specific configuration
configure :build do
  set :http_prefix, '/~dvskie001'

  # Minify CSS on build
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript
end

activate :deploy do |deploy|
  deploy.deploy_method = :rsync
  deploy.host = 'nightmare.cs.uct.ac.za'
  deploy.path = '/home/system/www/public_html/dvskie001'
  deploy.user = 'dvskie001'
  deploy.build_before = true
  deploy.clean = true
end
