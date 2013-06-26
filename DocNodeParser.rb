require 'rubygems'
require 'libxml'
require 'erb'

include LibXML

# DocNode represents a single website article.
# All properties are mutable and contain getter/setters.
# Constructor does not require any parameters.
# @category_list represents a list terms that "categorize" the article document
#

class DocNode
    attr_accessor :title, :link, :body, :pubDate

    def initialize() 
        @category_list = Array.new
    end

    def addCategory(category)
        @category_list.push(category)
    end

    def getCategories 
        @category_list
    end

    def get_binding
        binding()
    end
end

# DocNodeList is a collection of DocNodes
# This class represents a collection of document fragments retrieved by the SAX parser.
#
class DocNodeList
    def initialize()
        @list = Array.new
    end
    def add(docNode)
        @list  << docNode
    end
    def size
        @list.length
    end
    def get(index)
        @list[index]
    end
    def getList
        @list
    end
end

# DocNodeListHandler is a SAX event listener. As the SAX parser recognized 
# portions of the RSS XML document we are interested in, this class populates
# a collection of DocNodes (DocNoldeList)
# This class uses libxml-ruby
#
class DocNodeListHandler
    def initialize
        @start = false
        @docNodeList = DocNodeList.new
        @docNode = DocNode.new
        @sb = ""
    end 

    include XML::SaxParser::Callbacks

    def on_start_element(element, attributes)
        @sb = ""
        if element == "language" then
            @start = true
        end
        if element == "item" && @start == true then
            @docNode = DocNode.new
        end
    end

    def on_end_element_ns (name, prefix, uri)
        case name
            when "title" then @docNode.title = @sb
            when "item"  then 
                    @docNodeList.add(@docNode)
                    @docNode = DocNode.new
            when "pubDate" then @docNode.pubDate = @sb
            when "link" then @docNode.link = splitLink(@sb)
            when "description" then @docNode.body = @sb
            when "category" then @docNode.addCategory(@sb)
        end

    end

    def on_characters (chars)
        @sb << chars
    end

    def getList
        @docNodeList
    end
    def splitLink(link)
        elems = link.split("/")
        num_elems = (elems.length - 1)
        elems[num_elems]
    end
end

