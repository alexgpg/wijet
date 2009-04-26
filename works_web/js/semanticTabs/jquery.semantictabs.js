/*
jquery.semantictabs.js
Creates semantic tabs from nested divs
Chris Yates

Inspired by Niall Doherty's jQuery Coda-Slider v1.1 - http://www.ndoherty.com/coda-slider

Usage:
$("#mycontainer").semantictabs({
  panel:'mypanelclass',         //-- Selector of individual panel body
  head:'headelement',           //-- Selector of element containing panel header
  active:':first',              //-- Which panel to activate by default
  activate:':eq(2)'             //-- Argument used to activate panel programmatically
});

1 Nov 2007
*/

jQuery.fn.semantictabs = function(passedArgsObj) {
  /* defaults */
  args = {panel:'panel', head:'h2', active:':first', activate:false};

  /* override the defaults if necessary */
  for (var argName in passedArgsObj) {
    args[argName] = passedArgsObj[argName];
  }
  
  // Allow activation of specific tab, by index
	if (args.activate) {
	  return this.each(function(){
	    var container = jQuery(this);
			container.find("." + args.panel).hide();
			container.find("ul.tabs li").removeClass("active");
			container.find("div." + args.panel + ":eq(" + args.activate + ")").show();
			container.find("ul.tabs li:eq(" + args.activate + ")").addClass("active");      
	  });
	} else {
    return this.each(function(){
  		// Load behavior
  		var container = jQuery(this);
  		container.parent().find("." + args.panel).hide();
  		container.find("div." + args.panel + args.active).show();
  		container.prepend("<ul class=\"tabs semtabs\"></ul>");
  		container.find("." + args.panel).each( function() {
  		  var title = $(this).find(args.head).text();
  		  this.title = title;
  			container.find("ul.tabs").append("<li><a href=\"javascript:void(0);\">"+title+"</a></li>");
  		});
  		container.find("ul li" + args.active).addClass("active");
  		// Tab click behavior
  		container.find("ul.tabs li").click(function(){
  			container.find("." + args.panel).hide();
  			container.find("ul.tabs li").removeClass("active");
  			container.find("div." + args.panel + "[title='"+jQuery(this).text()+"']").show();
  			jQuery(this).addClass("active");
  		});
  		container.find("#remtabs").click(function(){
  			container.find("ul.tabs").remove();
  			container.find("." + args.container + " ." + args.panel).show();
  			container.find("#remtabs").remove();
  		});
                container.find("ul.tabs li").contextMenu({
                  menu: 'tabCMenu'
                }, function(action, el, pos) {
//                   Ass.voice():
                    CList.addItem();
                  alert(
                    'Action: ' + action + '\n\n' +
            //        'Element text: ' + $(el).text() + '\n\n' + 
            //        'X: ' + pos.x + '  Y: ' + pos.y + ' (relative to element)\n\n' + 
            //        'X: ' + pos.docX + '  Y: ' + pos.docY+ ' (relative to document)\n\n' +
                    'id: ' + $(el).attr("id")
                    +'\n\nname: ' + $(el).attr("name")
//                     + ass
                    );
                });
                  
//                });
  	});
	}
		
};
