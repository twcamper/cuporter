$(document).ready( function() {
  $(".report > ul").addClass("filetree");
  $(".report > ul > li, li.feature").addClass("open");
  $(".dir > .properties").addClass("folder");
//  $(".file > .properties").addClass("file");
  $(".report > ul.children").treeview({
    collapsed: true,
    animated: 120,
    control:"#expand-collapse"
  });
});
