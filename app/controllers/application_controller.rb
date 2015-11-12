# encoding: utf-8
require 'better_errors'

class ApplicationController < Sinatra::Base
  helpers ApplicationHelper

  set :views, File.expand_path('../../views', __FILE__)

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
end