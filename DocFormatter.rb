require "erb"

# This class creates an html document.
# The contstructor takes four parameters.
# - docNode contains the document fragments parsed from RSS XML document
# - linkText The text (description) of a link located at the documents top section. 
#   Typically links to either the website index.html (table of contents) or a "about me" page.
# - href The url portion of the link located at the the document top section. Corresponding
#   url to "linkText"
# - homeLinks is a boolean value. True means we render links to the table of contents index,html document. 

class DocFormatter
    include ERB::Util

    attr_accessor :docNode, :linkText, :href, :template, :homeLinks

    def initialize(docNode, linkText, href, homeLinks = false)
        @docNode = docNode
        @linkText = linkText
        @href = href
        @homeLinks = homeLinks
        @style = 
            %{<style>
              .wow {
                color:white;
              }
              .wee {
                color:gold;
              }
              .contact:hoover:after {
                content: "<div>lorinmk@public-action.org</div>";
              }
              #contactbox {
                    font-weight: bold;
                    margin-left: -10px;
                    width:90%;
                    background:white;
                    box-shadow:10px 10px 5px #888;
                }
              @media all and (max-width: 480px) {
                .greeting {
                  margin-bottom: 5px;
                }
              }
            </style>
            }

        @contactBoxJS =
                %{<script>
                var ContactBox = function(target_el) {
                    this.init = function(target_el) {
                        this.targel_el = target_el;
                        this.state = false;
                    };
                    this.render = function() {
                        var msg = "lorinmk @ public-action.org";
                        var div = document.createElement("div");
                        div.setAttribute("class", "alert alert-block alert-info");
                        div.setAttribute("id", "contactbox");
                        div.textContent = msg;
                        var cache = this.targel_el.innerHTML;
                        this.targel_el.innerHTML = div.outerHTML + cache;
                    };
                    this.hide = function() {
                        var contactBox = document.querySelector(\"#contactbox\");
                        this.targel_el.removeChild(contactBox);
                    };
                    this.toggle = function() {
                        if (this.state === true) {
                            this.hide();
                            this.state = false;
                        } else {
                            this.render();
                            this.state = true;
                        }
                    };
                    this.init(target_el);
                };
                var ContactListener = function(event) {
                        event.preventDefault();
                        var origin = event.target.tagName;
                        contactBox.toggle();
                };
            </script>
        }


        @docReadyJS =
               %{
                <script>
                    document.onreadystatechange = function () {
                        if (document.readyState === "complete\") {
                            var contactDiv = document.querySelector("#contact");
                            contactBox = new ContactBox(contactDiv);
                            contactDiv.addEventListener("click", ContactListener, true); 
                        }
                    };
                </script>}

        @docType = "<!DOCTYPE html>"

      @template = 
      %{<html>
        <head>
          <title><%= @docNode.title %></title>
          <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link type="text/css" href="css/bootstrap/css/bootstrap.min.css" media="all" rel="stylesheet" id="bootstrap"/>
        <%= @style %>
        <link rel="shortcut icon" href="favicon.png"/>
        <link rel="prerender" href="http://public-action.org/mob/index.html" />
        <%= @contactBoxJS %>
       </head>
       <body>
         <div class="container-fluid">
            <div class="navbar navbar-inverse">
                <div class="navbar-inner">
                  <ul class="nav">
                    <li><a class="brand" href="#"><span class="wow">Public</span> <span class="wee">Action</span></a></li>
                    <li><a href=<%= @href %>><%= @linkText %></a></li>
                  </ul>
                </div>
           </div>
        </div>
       <div class="container-fluid">
         <article>
           <% if @homeLinks then %> 
            <div class="page-header">
                <h4 class="h4"><%= @docNode.title %></h4>
                <div class="pull-right"><a href="index.html"><i class="icon-home"></i> - Home</a></div>
           </div>
            <% end %>
           <%= @docNode.body %>
         </article>
           <%  if @homeLinks then %>
        <div class="pull-right">
          <a href="index.html"><i class="icon-home"></i> - Home</a>
         </div>
           <% end %>
        </div>
         <%= @docReadyJS %>
        </body>
      </html>
      }

    end

    def get_binding
        binding()
    end

    def render()
        ERB.new(@template).result(get_binding())
    end
end

