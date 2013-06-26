require_relative "DocNodeParser"

# IndexFile represent our web site table of contents document. E.G. index.html . 
#  param sets a content header for the table of contents   E.G. Our Sites Articles
#  param docList is a collection of DocNode class instances.
#  Each docNode represents a html document (article/webpage).
#
#
class IndexFile

    attr_accessor :body

    def initialize(title,docList)
        @title = title
        @docList = docList
    end

    def generateBody
        @body = 
        "<ul class=\"nav nav-list\">\n
            <li class=\"nav-header\">#{@title}</li>\n"
        @docList.each { |doc| @body << "<li><a href=\"#{fullLink(doc.link)}\">#{doc.title}</a></li>\n"}
        @body << "</ul>"
    end

    def fullLink(link)
        link + ".html"
    end

    def toDocNode
        docNode = DocNode.new
        docNode.title = @title
        docNode.link = "index.html"
        docNode.body = generateBody()
        docNode
    end

end

