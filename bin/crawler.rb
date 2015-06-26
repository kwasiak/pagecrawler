#!/usr/bin/env ruby

raise "Expected url of the site to be parsed" if ARGV.size != 1

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'core/crawler_core'
require 'uri'

url = URI(ARGV[0].to_s)
Core::CrawlerCore.new.crawl_page(url)
