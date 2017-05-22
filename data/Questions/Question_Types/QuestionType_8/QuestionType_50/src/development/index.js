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
        // *CUSTOM*

        $cleanedData["questions"]=(typeof $props["questions"] == "undefined")?[]:$props["questions"];

        return $cleanedData;//This is used in render
    },

    render:function($_containerElement){
        var $this=this;
        //*CUSTOM*

        /*******************************************************************/
        var html="<div class='col-lg-12'>"+
                 "      <div class='col-lg-12>'"+
                 "           <h1>Set the Question</h1>"+
                 "           <input type='text' class='form-control questionInput'>"+
                 "      </div>"+
                 "      <div class='col-lg-12>'"+
                 "           <h1>Add Questions <span class='btn btn-primary addBtn'>Add</span></h1>"+
                 "           <input type='text' class='form-control addQuestionText'>"+
                 "      </div>"+
                 "      <div class='questions'></div>"+
                 "</div>";
        var container=$(html);

        /*******************************************************************/
        /* Get Important Components for later use                          */
        /*******************************************************************/
        var addBtn=container.find(".addBtn"); // I think I want to make a change here... You did make a change there.
        var inputText=container.find(".addQuestionText");
        var questionsContainer=container.find(".questions");
        var questionInput=container.find(".questionInput");
        questionInput.val($this.$_cleanedData["question"]);
        var createQuestionComponent=function(item){
            var ItemComponent=$(
                "<div class='questionItem'>"+
                "       <span class='btn btn-danger btnDeleteAnswer'><span class='glyphicon glyphicon-remove'></span>"+
                "       </span><span class='setAsAnswerBtn btn btn-default'>Set As Correct Answer</span>"+
                "       <span class='questionConent'>"+item+"</span> "+
                "</div>");
            //Put the item in the element so we dont loose it
            ItemComponent.data("itemQuestion",item);

            ItemComponent.find(".setAsAnswerBtn").click(function(){
                var $parent=$(this).parents(".questions:first");
                $parent.find(".setAsAnswerBtn[set]")
                    .removeClass("btn-success")
                    .addClass("btn-default")
                    .removeAttr("set");

                $(this)
                    .removeClass("btn-default")
                    .addClass("btn-success")
                    .attr("set",true);

                $this.setAnswer($(this).parents(".questionItem:first").data("itemQuestion"));
            });

            //Allow the delete of a question
            ItemComponent.find(".btnDeleteAnswer").click(function(){
                var item=$(this).parents(".questionItem:first").data("itemQuestion");
                var indexOfItem=$this.$_cleanedData["questions"].indexOf(item);
                if(indexOfItem==-1){
                    //Error...Later add the MessageBox thing I made for work
                }
                $this.$_cleanedData["questions"].splice(indexOfItem,1);

                $(this).parents(".questionItem:first").remove();
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
        /* Add Functionality to add button                                 */
        /*******************************************************************/
        addBtn.click(function(){
            var text=$(".addQuestionText").val();
            var ItemComponent=createQuestionComponent(text);
            if(typeof $this.$_cleanedData["questions"]=="undefined"){
                $this.$_cleanedData["questions"]=[];
            }
            $this.$_cleanedData["questions"].push(text);
            questionsContainer.append(ItemComponent);
        });
        container.find(".questionInput").change(function(){
            $this.$_cleanedData["question"]=$(".questionInput").val();
        });

        /*******************************************************************/
        var questionAnswer=container.find(".questionConent:contains('"+this.getAnswer()+"')");
        questionAnswer
                    .prev(".setAsAnswerBtn")
                    .removeClass("btn-default")
                    .addClass("btn-success")
                    .attr("set",true);

        /*******************************************************************/
        container.appendTo($_containerElement);

    },

    beforeSubmitingChanges:function($_paramers){
        var $this=this;
        //*CUSTOM*

        //alert(JSON.stringify($_paramers))
    },

    afterSubmitingChanges:function(response){
        var $this=this;
        //*CUSTOM*

        if(!response.success){
            //alert("Error Happend");
        }
        //alert(JSON.stringify(response))
    }

});