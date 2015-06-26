module Crawler
  class CrawlerNode

    attr_accessor :current_page_url

    attr_accessor :java_script_urls
    attr_accessor :style_sheet_urls
    attr_accessor :image_urls
    attr_accessor :external_link_urls

    attr_accessor :child_nodes

    def print_content(level = 0)

      puts '--'*level + 'Node URL: ' + current_page_url.to_s

      # print each collection
      print_collection(java_script_urls, level)
      print_collection(style_sheet_urls, level)
      print_collection(image_urls, level)
      print_collection(external_link_urls, level)
      print_collection(child_nodes, level)
    end

    private

    def print_collection(collection, level)
      if collection && collection.size > 0

        collection.each do |element|

          if (element.kind_of?(CrawlerNode))
            element.print_content(level + 1)
          else
            puts '--'*level + element
          end
        end
      end
    end

  end
end