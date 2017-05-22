  
  (function(){

    var ConvertBase = function (num) {
        return {
            from : function (baseFrom) {
                return {
                    to : function (baseTo) {
                        return parseInt(num, baseFrom).toString(baseTo);
                    }
                };
            }
        };
    };
        
    // binary to decimal
    ConvertBase.bin2dec = function (num) {
        return ConvertBase(num).from(2).to(10);
    };
    
    // binary to hexadecimal
    ConvertBase.bin2hex = function (num) {
        return ConvertBase(num).from(2).to(16);
    };
    
    // decimal to binary
    ConvertBase.dec2bin = function (num) {
        return ConvertBase(num).from(10).to(2);
    };
    
    // decimal to hexadecimal
    ConvertBase.dec2hex = function (num) {
        return ConvertBase(num).from(10).to(16);
    };
    
    // hexadecimal to binary
    ConvertBase.hex2bin = function (num) {
        return ConvertBase(num).from(16).to(2);
    };
    
    // hexadecimal to decimal
    ConvertBase.hex2dec = function (num) {
        return ConvertBase(num).from(16).to(10);
    };
    
    this.ConvertBase = ConvertBase;
    
})(this);

function ConvertingStatus($questionWiget)
{
	this.element=$("<div class='col-lg-12'>"+
	               "  <div id='MenuFrom' class='dropdown'>"+
				   "     <button class='btn btn-primary dropdown-toggle' type='button' id='dropdownMenuFrom' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>"+
				   "        From <span class='indicator'></span>"+
				   "     </button>"+
				   "     <div class='dropdown-menu' aria-labelledby='dropdownMenuFrom'>"+
				   "     </div>"+
				   "  </div>"+
				   "  <span style='margin-left:15px;margin-right:15px'>To...</span>"+
				   "  <div id='MenuTo' class='dropdown'>"+
				   "     <button class='btn btn-primary dropdown-toggle' type='button' id='dropdownMenuTo' data-toggle='dropdown' aria-haspopup='true' aria-expanded='false'>"+
				   "        To <span class='indicator'></span>"+
				   "     </button>"+
				   "     <div class='dropdown-menu' aria-labelledby='dropdownMenuTo'>"+
				   "     </div>"+
				   "  </div>");
	
	this.parent=$questionWiget;
	
	/***********************************************************************/
	this.from={value:"",menu:this.element.find("#MenuFrom").find(".dropdown-menu"),
	indicator:this.element.find("#MenuFrom").find(".indicator")};
	
	this.to={value:"",menu:this.element.find("#MenuTo").find(".dropdown-menu"),
	indicator:this.element.find("#MenuTo").find(".indicator")};
	
	/***********************************************************************/
	var $this=this;
	var bases=["bin","hex","dec"];
	bases.forEach(function(item){
		$this.from.menu.append($("<li root='from' value='"+item+"'><a class='dropdown-item' href='#' >"+item+"</a></li>"));
		$this.to.menu.append($("<li root='to'  value='"+item+"'><a class='dropdown-item' href='#' >"+item+"</a></li>"));
	});
	
	
	
	/***********************************************************************/
	this.element.on("click","li",function(){
		var value=$(this).attr("value");
		var root=$(this).attr("root");
		$this[root].value=value;
		$this.trigger("updated");
	});
	
	
	/***********************************************************************/
	this.on("updated",function(){
		$this.from.indicator.text($this.from.value);
		$this.to.indicator.text($this.to.value);
		
		$this.parent.$_cleanedData["settings"]["convert"]["from"]=$this.from.value;
		$this.parent.$_cleanedData["settings"]["convert"]["to"]=$this.to.value;
	});
	
}
Tools.inheritsFrom(ConvertingStatus, EventHandler);
$.extend(ConvertingStatus.prototype,{
	init:function(){
		/***********************************************************************/
		this.from.menu.find(".dropdown-item:first").trigger("click");
		this.to.menu.find(".dropdown-item:first").trigger("click");
	}
});

  
/***************************************************************************/
/* *IMPORTANT*                                                             */
/* This code should not be changed. Only in the comments *CUSTOM* Should  */
/* you change code                                                         */
/***************************************************************************/
$.extend(QuestionWidget.prototype, {

    /***********************************************************************/
    /* Functions part of QuestionWidget                                    */
    /*                                                                     */
    /* this.$_cleanedData
    /* setAnswer(answer,callback)                                          */
    /***********************************************************************/

    /***********************************************************************/
    /* Will be called in the beginning for any setup of the parameters      */
    /* $props will be the object that will given to your deployment side   */
    /***********************************************************************/
    setup:function($props){
        var $this=this;
        var $cleanedData={};
	this.subwiget=new ConvertingStatus(this);
        // *CUSTOM*
        $cleanedData["questions"]=(typeof $props["questions"] == "undefined")?[]:$props["questions"];
        $cleanedData["settings"]=(typeof $props["settings"] == "undefined")?{}:$props["settings"];
		
	$cleanedData["settings"]["convert"]=(typeof $cleanedData["settings"]["convert"] == "undefined")?{}:$cleanedData["settings"]["convert"];
		

        return $cleanedData;//This is used in render
    },

    render:function($_containerElement){
        var $this=this;
        //* CUSTOM*

	/*******************************************************************/
	this.subwiget.init();
		
        this.setAnswer("this-one");

        /*******************************************************************/
        this.subwiget.element.appendTo($_containerElement);

    },

    beforeSubmitingChanges:function($_paramers){
        var $this=this;
        //*CUSTOM*

        
    },

    afterSubmitingChanges:function(response){
        var $this=this;
        //*CUSTOM*

        
    }

});