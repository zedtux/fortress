require 'fortress/configuration'
require 'fortress/controller'
require 'fortress/controller_interface'
require 'fortress/mechanism'
require 'fortress/version'

ActionController::Base.send(:include, Fortress::Controller)
