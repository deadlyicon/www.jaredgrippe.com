// Endless Page
// written by Jared Grippe
// Inspired by RailsCasts


// Window Events
//  nearBottom
//  fullLoaded
//  nearBottom

var EndlessPage;

(function(){

  var running = false;
  var eventElement = new Element('div');

  EndlessPage = {
    totalPages: null, // If null page requests stop after first "records not found error" response
    currentPage: 1,
    onLoad: true, // If set to false EndlessPage does not start on load
    distanceFromBottom: 150,
    
    start: function(){
      if (running) return;
      running = true;
      Event.observe(window,'scroll',onScroll);
      return this;
    },
    
    stop: function(){
      if (!running) return;
      running = false;
      Event.stopObserving(window,'scroll',onScroll);
      return this;
    },
    
    nearBottomOfPage: function(){
      return scrollDistanceFromBottom() < EndlessPage.distanceFromBottom;
    },
    
    observe: function(event,handler){
      Element.observe(eventElement,'EndlessPage:'+event,handler)
      return this;
    },
    
    stopObserving: function(event, handler){
      Event.stopObserving(eventElement,event,handler);
      return this;
    }
  }
  
  function onScroll(event){
    if ( EndlessPage.nearBottomOfPage() ) {
      Element.fire(eventElement,'EndlessPage:nearBottom');
    };
  };
  
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
