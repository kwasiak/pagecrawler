require 'crawler/crawler_main'
require 'uri'

module Core
  class CrawlerCore

    def crawl_page(uri)

      root_host_name = uri.host

      # list of already created nodes - to make sure
      # we won't visit the same noded again
      created_nodes = Hash.new()

      # crawl the page
      root_node = Crawler::CrawlerMain.new().crawl_page(uri, root_host_name, created_nodes)

      # print out result of the parsing
      root_node.print_content()
    end

  end
end