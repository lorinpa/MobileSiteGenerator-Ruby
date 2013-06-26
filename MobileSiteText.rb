# Utility class which edits each article's body.
# - We replace the contact box with a mobile friendly contact mechanism.
# - We replace the href to JavaScript teasers with our new mobile JavaScript index page
# - We replace the href to the Polylot teasers with our new mobile Polyglot index page
#

class MobileSiteText
  def findAndReplace(body)
    token = " - I'm an experienced developer. My main interest is in new technology. Please use our contact box <a href=\"http://public-action.org/contact\" target=\"_blank\">here</a> if you are interested in hiring me. Please no recruiters :)"
    replace = "is an experienced developer focused on  new technology. Open for work (contract or hire), <a id=\"contact\" href=\"http://public-action.org/mob/contact\" target=\"_blank\">Drop Lorin  a note. </a> <span class=\"muted\">  Please no recruiters :)</span>"
    @body = body.gsub(token,replace)

    token = "http://public-action.org/category/technology/javascript"
    replace = "js-index.html"
    @body = @body.gsub(token,replace)

    token = "http://public-action.org/category/technology/polyglot"
    replace = "polyglot-index.html"
    @body = @body.gsub(token,replace)

  end

end
