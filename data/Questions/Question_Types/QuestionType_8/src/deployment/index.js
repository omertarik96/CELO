
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
    setup:function($props){
        //*CUSTOM*
        var $this=this;
        var $cleanedData={};

        $cleanedData["questions"]=(typeof $props["questions"] == "undefined")?[]:$props["questions"];

        return $cleanedData;//This is used in render


    },

    render:function(parameters){
        var $this=this;
        //*CUSTOM*

        /*******************************************************************/
        var html="<div class='col-lg-12'>"+
        "      <div class='questions'></div>"+
        "</div>";
        var container=$(html);

        /*******************************************************************/
        /* Get Important Components for later use                          */
        /*******************************************************************/
        var questionsContainer=container.find(".questions");

        var createQuestionComponent=function(item){
            var ItemComponent=$(
                "<div class='questionItem'>"+
                "       <span class='btn btn-default'><span class='answerChoice glyphicon glyphicon-unchecked'></span>"+
                "       <span class='questionConent'>"+item+"</span> "+
                "</div>");
            ItemComponent.data("itemQuestion",item);

            //Allow the delete of a question
            ItemComponent.click(function(){
                $(this).find(".answerChoice[my-choice]")
                    .removeClass("glyphicon-check")
                    .addClass("glyphicon-unchecked")
                    .removeAttr("my-choice");
                $(this)
                    .removeClass("glyphicon-unchecked")
                    .addClass("glyphicon-check")
                    .attr("my-choice",true);

                $this.setAnswer($(this).data("itemQuestion"));
            });

            return ItemComponent;
        };

        /*******************************************************************/
        /* Populate current questions                                      */
        /*******************************************************************/
        $this.$_cleanedData.questions.forEach(function(item){
            var ItemComponent=createQuestionComponent(item);

            questionsContainer.append(ItemComponent);
        });



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