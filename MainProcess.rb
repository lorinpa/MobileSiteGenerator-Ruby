require_relative "IndexFile"
require_relative "DocNodeParser"
require_relative "DocFormatter"
require_relative "FileProcess"
require_relative "SiteMap"
require_relative "MobileSiteText"

# A simple command line utility which converts a website's rss xml feed in
# to a mobilzed version of the website.
#
# param args the command line arguments.. Required: -in INFILE -out OUTPUTDIR 
# INFILE represents the rss xml feed saved to disk as a file.
# OUTPUTDIR is a directory name which this program creates. The output directory location
# is created relative to the current directory.
#
#
def main(srcFile, targetDir) 
    io = File.open(srcFile, 'rb')
    parser = XML::SaxParser.io(io,:encoding => XML::Encoding::UTF_8)
    parser.callbacks = DocNodeListHandler.new
    parser.parse
    list = parser.callbacks.getList.getList
    # fix the contact box and change category links
    mobileText = MobileSiteText.new
    list.each { |doc|  doc.body = mobileText.findAndReplace(doc.body)}

    indexFile = IndexFile.new("Public Action Articles",list)
    indexDoc = indexFile.toDocNode

    fileProcess = FileProcess.new
    fileProcess.createDir(targetDir)
    fileProcess.copySet("static-content","mob")

    df = DocFormatter.new(indexDoc,"AA-side","a-side.html")
    File.open(targetDir+"/index.html","w+") do |f| f.write(df.render) end

    indexFileTitle = "A-side"
    indexFileHref= "index.html"

    df.homeLinks = true
    df.linkText = indexFileTitle
    df.href = indexFileHref 

    jsList = Array.new
    polyList = Array.new

    # As we look through the docNodes 
    # create an html document file and capture a list of file name/links
    # for our new JavaScript and Polglot index pages
    # Npte! We need to trim the category term (strip)
    list.each {
        |doc| 
            df.docNode = doc
            fileProcess.writeFile(targetDir + "/" + doc.link+".html",  df.render)
            categories = doc.getCategories
            categories.each { |category| 
            # we need to trim the value then compare
            case category.strip
                when "JavaScript" then jsList.push(doc)
                when "Polyglot" then polyList.push(doc)
            end
        }
    }

    # Write out the new JavaScript index page.
    #
    jsViewFile = IndexFile.new("Public Action JavaScript Articles",jsList)
    jsViewDoc = jsViewFile.toDocNode
    df = DocFormatter.new(jsViewDoc,"AA-side","a-side.html")
    File.open(targetDir+"/js-index.html","w+") do |f| f.write(df.render) end

    # Write out the new Polyglot index page.
    #
    polyViewFile = IndexFile.new("Public Action PolyGlot Articles",polyList)
    polyViewDoc = polyViewFile.toDocNode
    df = DocFormatter.new(polyViewDoc,"AA-side","a-side.html")
    File.open(targetDir+"/polyglot-index.html","w+") do |f| f.write(df.render) end

    siteMap = SiteMap.new("http://public-action.org/mob")
    siteMap.writeOutputFile(targetDir+"/sitemap.xml",list)
    puts "Execution complete."

end

# Handle the command line arguments.
#
args = ARGF.argv
valid = false

if args.length != 4 then
    puts "Usage: -in SRCFILE -out DESTDIR"
else 
    if args[0] == "-in" && args[2] == "-out" then
        srcFile = args[1]
        cwd = Dir.getwd
        targetDir = cwd + "/" + args[3]
        main(srcFile, targetDir)
    else
        puts "Usage: -in SRCFILE -out DESTDIR"
    end
end

