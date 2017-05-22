 



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
        var $cleanedData=$props;
        // *CUSTOM*
        
        $cleanedData["question"]=(typeof $props["question"] == "undefined")?"New Question":$props["question"];

        return $cleanedData;//This is used in render
    },

    render:function($_containerElement){
        var $this=this;
        // *CUSTOM*

        /*******************************************************************/
        var html="<div class='well col-lg-12'>"+
                 "      <div class='col-lg-12'>"+
                 "           <input type='text' class='form-control addQuestionText' value='"+$this.$_cleanedData.question+"'>"+
                 "      </div>"+
                 "      <div style='margin-top:10px' class='answerChoices col-lg-12'></div>"+
                 "</div>";
        var container=$(html);
        $this.helper={};
        container.find(".addQuestionText").on("change",function(){
                $this.$_cleanedData.question=container.find(".addQuestionText").val();
        });
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
             maxWidth=0;
             container.find('.answerChoice').each(function(index){
                  $(this).find(".prefix").html("<b>"+letters[index%letters.length]+"</b>.")
                  maxWidth=Math.max(maxWidth,$(this).outerWidth(true));
             });
             container.find('.answerChoice').each(function(index){
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

            if($this.getAnswer()==item){
                 ItemComponent.trigger('set-as-answer');
            }
            updateLettering();
            return ItemComponent;
        };

        updateLettering();
        /*******************************************************************/
        /* Populate current questions                                      */
        /*******************************************************************/
        createQuestionComponent("True");
        createQuestionComponent("False");


        /*******************************************************************/
        container.appendTo($_containerElement);

    },

    beforeSubmitingChanges:function($_paramers){
        var $this=this;
        //*CUSTOM*

        alert(JSON.stringify($_paramers))
    },

    afterSubmitingChanges:function(response){
        var $this=this;
        //*CUSTOM*

        if(!response.success){
            alert("Error Happend");
        }
        alert(JSON.stringify(response))
    }

});