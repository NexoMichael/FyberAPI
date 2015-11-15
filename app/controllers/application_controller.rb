# encoding: utf-8
require 'better_errors'
require 'sinatra/assetpack'
require 'sinatra_more/markup_plugin'
require 'sinatra_more/render_plugin'

class ApplicationController < Sinatra::Base
  set :root, File.expand_path('../../', __FILE__)
  set :views, File.expand_path('../../views', __FILE__)

  helpers ApplicationHelper
  register Sinatra::AssetPack
  register SinatraMore::MarkupPlugin
  register SinatraMore::RenderPlugin

  configure :production do
    enable :logging
    set :haml, { ugly: true }
    set :clean_trace, true
  end

  configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = __dir__
    enable :logging
  end

  assets do
    serve '/js', from: 'assets/js'
    serve '/css', from: 'assets/css'

    js :app, '/js/app.js', ['/js/jquery-2.1.4.min.js', '/js/main.js']
    css :app, '/css/app.css', ['/css/bootstrap.css', '/css/main.sass']

    js_compression :jsmin
    css_compression :sass
  end
end