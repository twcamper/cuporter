<!--/*--><root><![CDATA[<!--*/-->

  var FEATURES = "li.feature .feature_name";
  var TAGS = "li.tag .tag_name";
  
  $(document).ready(function() {
    $(FEATURES).css('cursor', 'pointer');
    $(FEATURES).click(function() {
      $(this).siblings().toggle(250);
    });

    $(TAGS).css('cursor', 'pointer');
    $(TAGS).click(function() {
      $(this).siblings().toggle(250);
    });

    $("#collapser").css('cursor', 'pointer');
    $("#collapser").click(function() {
      $(TAGS).siblings().hide();
      $(FEATURES).siblings().hide();
    });
    
    $("#expand_tags").css('cursor', 'pointer');
    $("#expand_tags").click(function() {
      $(TAGS).siblings().show();
      $(FEATURES).siblings().hide();
    });

    $("#expand_all").css('cursor', 'pointer');
    $("#expand_all").click(function() {
      $(TAGS).siblings().show();
      $(FEATURES).siblings().show();
    });

    $("#expand_features").css('cursor', 'pointer');
    $("#expand_features").click(function() {
      $(FEATURES).siblings().show();
    });

    $("#collapse_features").css('cursor', 'pointer');
    $("#collapse_features").click(function() {
      $(FEATURES).siblings().hide();
    });

    // load page with features collapsed
    $("#collapser, #collapse_features").click();
  })

<!--/*-->]]></root><!--*/-->
