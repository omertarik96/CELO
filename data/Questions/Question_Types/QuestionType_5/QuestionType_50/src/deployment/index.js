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
        // * CUSTOM*
        var $this=this;
        var $cleanedData=$props;

        $cleanedData["questions"]=(typeof $props["questions"] == "undefined")?[]:$props["questions"];

        return $cleanedData;//This is used in render


    },

    render:function($_containerElement){
        var $this=this;
        //*CUSTOM*

        /*******************************************************************/
        var html="<div class='col-lg-12'>"+
        "      <h2 class='question'></h2>"+
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
                "       <span class=''><span class='btn btn-default answerChoice glyphicon glyphicon-unchecked'></span>"+
                "       <span class='questionConent'>"+item+"</span> "+
                "</div>");
            ItemComponent.data("itemQuestion",item);

            //Allow the delete of a question
            ItemComponent.find('.answerChoice').click(function(){
                $(this).parents(".questions:first").find(".answerChoice")
                    .removeClass("glyphicon-check")
                    .addClass("glyphicon-unchecked")
                    .removeAttr("my-choice");
                $(this)
                    .removeClass("glyphicon-unchecked")
                    .addClass("glyphicon-check")
                    .attr("my-choice",true);

                $this.setAnswer($(this).parents('.questionItem:first').data("itemQuestion"));
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

        container.find(".question").text($this.$_cleanedData["question"]);

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
