# encoding: utf-8
class FyberAPIController < ApplicationController
  get '/' do
    haml :index
  end
end