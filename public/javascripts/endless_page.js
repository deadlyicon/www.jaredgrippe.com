// Endless Page
// written by Jared Grippe
// Inspired by RailsCasts


// Window Events
//  nearBottom
//  fullLoaded
//  nearBottom

var EndlessPage;

(function(){

  var onScroll = null;

  EndlessPage = {
    totalPages: null, // If null page requests stop after first "records not found error" response
    currentPage: 1,
    onLoad: true, // If set to false EndlessPage does not start on load
    distanceFromBottom: 200,
    
    start: function(){
      if (onScroll != null) return;
      onScroll = function(){
        if ( this.nearBottomOfPage() ) {
          Element.fire(window,'EndlessPage:nearBottom');
        };
      }.bind(this);
      Event.observe(window,'scroll',onScroll);
      return this;
    },
    
    stop: function(){
      Event.stopObserving(window,'scroll',onScroll);
      onScroll = null;
      return this;
    },
    
    scrollEvent: function(){
      return scrollEvent;
    },
    
    nearBottomOfPage: function(){
      return scrollDistanceFromBottom() < EndlessPage.distanceFromBottom;
    },
    
    observe: function(event, handler){
      Element.observe(window,'EndlessPage:'+event, handler)
      return this;
    }
  }
  
  function scrollDistanceFromBottom(argument) {
    return pageHeight() - (window.pageYOffset + window.innerHeight);
  };

  function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
  };
  
  
  
  Event.observe(window,'dom:loaded',function(){
    if (EndlessPage.onLoad) EndlessPage.start();
  });
  
})();
