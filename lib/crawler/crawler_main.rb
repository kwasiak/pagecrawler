require 'nokogiri'
require 'open-uri'
require 'crawler/crawler_node'

module Crawler
  class CrawlerMain

    def crawl_page(page_url, root_host_name, created_nodes)

      puts "Crawling: #{page_url}"

      page = Nokogiri::HTML(open(page_url))

      this_node =  CrawlerNode.new
      this_node.current_page_url = page_url
      this_node.image_urls = extract_properties(page, page_url, 'img', 'src')
      this_node.java_script_urls = extract_properties(page, page_url, 'script', 'src')
      this_node.style_sheet_urls = extract_properties(page, page_url, 'link', 'href')

      links = extract_properties(page, page_url, 'a', 'href')

      this_node.external_link_urls = []
      this_node.child_nodes = []

      # update list of created nodes before we go into crawl
      created_nodes[page_url] = this_node

      # for external links - just store them
      # for internal links - check if they are already created, grab node for that url if yes;
      #                      otherwise run crawling pracedure
      links.each do |link|

        if is_link_external?(link, root_host_name)
          this_node.external_link_urls << link
        else
          # check if we don't have this node created already
          this_node.child_nodes << (
            created_nodes.has_key?(link) ?
              created_nodes[link] :
              crawl_page(link, root_host_name, created_nodes)
          )
        end
      end

      # return newly created node
      this_node
    end

    private

    def extract_properties(html_page, page_url, tag, property)

      # use nokogiri selectors
      extracted_tags = html_page.css(tag)

      [] unless extracted_tags != nil

      extracted_tags.map { |script| script[property] } \
                          # select only links of the property, which are not empty
                          .select {|link| link } \
                           .map { |link| add_domain_to_link(page_url, link) }
    end

    def is_link_external?(url_str, root_host_name)

      input_uri = URI(url_str)
      root_domain = root_host_name[/\w+\.\w+$/]

      # make sure you will take into consideration root domain only (e.g.: google.com),
      # NOT the host name (www.google.com)
      !input_uri.host.downcase.include?('.' + root_domain) || !input_uri.host.downcase == root_domain
    end

    def add_domain_to_link(input_url, partial_link)

      current_url = input_url.kind_of?(URI) ? input_url : URI(input_url)

      # validate if link starts with http(s):// or //
      if !(partial_link[/^http(s?):\/\//]) && !partial_link.start_with?('//')
        # make sure we remove front slash from the partial URL
        "http://#{current_url.host}/#{partial_link.gsub(/^\//, '')}"
      else
        partial_link
      end
    end

  end
end