 


/***************************************************************************/
/* *IMPORTANT*                                                             */
/* This code should not be changed. Only in the comments *CUSTOM* Should  */
/* you change code                                                         */
/***************************************************************************/
$.extend(QuestionWidget.prototype, {

    /***********************************************************************/
    /* Functions part of QuestionWidget                                    */
    /*                                                                     */
    /* nextQuestion()                                                      */
    /* startTimer()                                                        */
    /* stopTimer()                                                         */
    /* initializeTimer(someObject for info)                                */
    /* setAnswer(anwer Choicen)                                               */
    /***********************************************************************/

    /***********************************************************************/
    /* Will be called in the beginning for any setup of the parameters      */
    /* $props will be the object that will given to your deployment side   */
    /***********************************************************************/
    setup: function($props){
        // *CUSTOM*
        var $this=this;
        var $cleanedData=$props;
        

        $cleanedData["question"]=(typeof $props["question"] == "undefined")?"New Question":$props["question"];

        return $cleanedData;//This is used in render


    },

    render:function($_containerElement){
        var $this=this;
        // *CUSTOM*

        /*******************************************************************/
        var html="<div class='well col-lg-12'>"+
                 "      <div class='col-lg-12'>"+
                 "           <h1>"+$this.$_cleanedData.question+"</h2>"+
                 "      </div>"+
                 "      <div style='margin-top:10px' class='answerChoices col-lg-12'></div>"+
                 "</div>";
        var container=$(html);
        $this.helper={};
        container.on('perform-some-updates',function(){
             updateLettering();
        });
        container.on("set-off-as-answer",".answerChoice",function(){
             $(this).removeClass("btn-success")
                    .addClass("btn-default")
                    .attr("set",false);     
        });
        container.on("set-as-answer",".answerChoice",function(){
             if(typeof $this.helper.setAnswer != 'undefined'){
                  $this.helper.setAnswer.trigger('set-off-as-answer');
             }
             $(this).removeClass("btn-default")
                    .addClass("btn-success")
                    .attr("set",true);     
             $this.helper.setAnswer=$(this);
             $this.setAnswer($(this).data('itemQuestion'));
        });
        container.on("click",".answerChoice",function(){
             $(this).trigger('set-as-answer');
        });
        
        
        /*******************************************************************/
        /* Get Important Components for later use                          */
        /*******************************************************************/
        var answerChoices=container.find(".answerChoices");
        var addQuestionText=container.find(".addQuestionText");

        /*******************************************************************/
        var updateLettering=function(){
             var letters=['A','B','C','D','E','F','G','H'];
           
             container.find('.answerChoice').each(function(index){
                  $(this).find(".prefix").html("<b>"+letters[index%letters.length]+"</b>.")
                  $(this).css("width",80);
             });
        };

        /*******************************************************************/
        var createQuestionComponent=function(item){
            
            var ItemComponent=$(
                "<span style='display:inline-block' class='answerChoice btn btn-default'><span class='prefix'></span>"+item+"</span>");
            //Put the item in the element so we dont loose it
            ItemComponent.data("itemQuestion",item);

            answerChoices.append($("<div style='margin:5px'>").append(ItemComponent));
            updateLettering();
            return ItemComponent;
        };


        /*******************************************************************/
        /* Populate current questions                                      */
        /*******************************************************************/
        createQuestionComponent("True");
        createQuestionComponent("False");

        
        /*******************************************************************/
        container.appendTo($_containerElement);

    },

    beforeAnswering:function(answerInfo){
        //*CUSTOM*
    },

    afterAnswering:function(answerResponse){
      //answerResponse.correct   =   boolean
      //answerResponse.hints     =   object
        //*CUSTOM*
    }

});