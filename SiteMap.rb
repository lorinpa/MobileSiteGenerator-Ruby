# SiteMap constructs a xml document used by search engines like
# Google to index our website artivles.
#
# Note! On my site the rss feed is published in descending order by publish data
# thus the first articles in the rss feed (for my site) has the most recent date
#

class SiteMap 

    def initialize(baseAddr)
        @baseAddr = baseAddr
    end

    def writeOutputFile(fileName, docList) 

        # Note! On my site the rss feed is published in descending order by publish data
        # thus then first articles in the rss feed (for my site) has the most recent date

        @output =
        "<urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\"
          xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
          xsi:schemaLocation=\"http://www.sitemaps.org/schemas/sitemap/0.9
          http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd\">
          <url>
            <loc>#{@baseAddr}</loc>
            <changefreq>daily</changefreq>
            <priority>1.0</priority>
            <lastmod>#{convertDate(docList[0].pubDate)}</lastmod>
          </url>"

         docList.each { |doc| @output << 
            "<url>
                <loc>#{fullLink(doc.link)}</loc>
                <lastmod>#{convertDate(doc.pubDate)}</lastmod>
            </url>"
          }
        @output << "</urlset>"

        File.open(fileName,"w+") do |f| f.write(@output) end
    end

    def fullLink(link)
        @baseAddr + "/"+ link + ".html"
    end

    def convertDate(date)
        elems = date.split(" ")
        elems[3] + "-" + convertMonth(elems[2]) + "-" + elems[1]
    end

    def convertMonth(monthStr) 
        case monthStr
            when "Jan" then "01"
            when "Feb" then "02"
            when "Mar" then "03"
            when "Apr" then "04"
            when "May" then "05"
            when "Jun" then "06"
            when "Jul" then "07"
            when "Aug" then "08"
            when "Sep" then "09"
            when "Oct" then "10"
            when "Nov" then "11"
            when "Dec" then "12"
        end
    end

end

