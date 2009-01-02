// Endless Page
// written by Jared Grippe
// Inspired by RailsCasts


// Window Events
//  nearBottom
//  fullyLoaded  //TODO
//  nearBottom   //TODO

var EndlessPage;

(function(){

  var running = false,
      eventElement = new Element('div'),
      periodicalExecuter
  ;

  EndlessPage = {
    contentElement: document.body,
    totalPages: null, // TODO If null page requests stop after first "records not found error" response
    currentPage: 1,
    onLoad: true, // If set to false EndlessPage does not start on load
    distanceFromBottom: 150,
    
    // If any of the functions in this array returns true we request more content
    conditions: [
      nearBottomOfPage,
      windowIsTallerThenLoadedContent
    ],
    
    start: function(){
      if (running) return;
      running = true;
      periodicalExecuter = new PeriodicalExecuter(doWeNeedMoreContent,1);
      return this;
    },
    
    stop: function(){
      if (!running) return;
      running = false;
      periodicalExecuter.stop();
      return this;
    },

    observe: function(event,handler){
      Element.observe(eventElement,'EndlessPage:'+event,handler)
      return this;
    },
    
    stopObserving: function(event, handler){
      Event.stopObserving(eventElement,event,handler);
      return this;
    },
    
    loadMoreContent: function(){
      this.stop();
      new Ajax.Request(this.url, {
        parameters: Object.toQueryString({
          page: (this.currentPage += 1)
        }),
        asynchronous:true, 
        evalScripts:true, 
        method:'get'
      });
      return this;
    }

  }
  
  function doWeNeedMoreContent(event){
    // console.log("checking");
    if ( Try.these.apply(this, EndlessPage.conditions) ) {
      // console.log("loading");
      periodicalExecuter.stop();
      EndlessPage.loadMoreContent();
      eventElement.fire('EndlessPage:nearBottom')
    };
  };
  
  function windowIsTallerThenLoadedContent() {
    return (window.scrollMaxY <= 0)
  };
    
  function nearBottomOfPage(){
    return scrollDistanceFromBottom() < EndlessPage.distanceFromBottom;
  };
  
  function scrollDistanceFromBottom() {
    return pageHeight() - (window.pageYOffset + window.innerHeight);
  };

  function pageHeight() {
    return Math.max(document.body.scrollHeight, document.body.offsetHeight);
  };
  
  
  Event.observe(window,'dom:loaded',function(){
    console.log("dom loaded");
    if (EndlessPage.onLoad) EndlessPage.start();
  });
  
})();
