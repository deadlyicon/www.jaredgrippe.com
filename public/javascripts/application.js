// JaredGrippe.com scoped objects
var JG = {};
var ENV = ENV || {};


// Remove all flash notices after 5 seconds
Event.observe(window,'load',function(event){
  (function(){
    $$('.flash').each(function(flash) { 
      Effect.BlindUp(flash, {duration: 0.5});
      // Effect.Fade({ duration: 0.5, from: 1, to: 0 });
    });
  }).delay(5);
});


// var Link = Class.create({
//   initialize : function(attributes){
//     attributes = {} || attributes;
//     var element = this.element = Element.new('a', attributes);
//     
//   }
// });


Element.addMethods('input',{
  innerTextDimentions: function(input){
    var FONT_STYLES = ['fontFamily','fontSize','fontWeight'];

    var styles = FONT_STYLES.inject({},function(styles, style){
      styles[style] = input.getStyle(style);
      return styles;
    });
    
    var mock = new Element('span').setStyle(styles).setStyle({
      position : 'absolute',
      top: '-1000px',
      left: '-1000px',
      padding: 'none',
      margin: 'none'
    }).update(input.value)
    
    new Insertion.Bottom(document.body, mock)
      
    var dimentions = [ mock.clientWidth, mock.clientHeight ];
    dimentions.width = function(){ return this[0]; };
    dimentions.height = function(){ return this[1]; };
    
    mock.remove();
    
    return dimentions;
  },
  innerTextWidth:function(input){
    return input.innerTextDimentions().width()
  },
  innerTextHeight:function(input){
    return input.innerTextDimentions().height()
  },
  fitToInnerText: function(input){
    input.setStyle({width: input.innerTextWidth()+'px' });
  },
  autoResize: function(input){
    input.fitToInnerText();
    if (typeof input._autoResizeObserver == 'undefined')
      input._autoResizeObserver = input.observe('keydown', input.fitToInnerText.bind(input));
    return input;
  }
})