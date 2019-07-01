<div id="dialogError" class="trash" title="Erreur souscription" style="display:none;">
    <div style="display: inline;text-align: left">
        <{$this->message}>
    </div>
    <table style="width: 100%;margin-top: 50px;">
            <tbody>
                <tr>
                    <td style="text-align: center">
                        
                        <input class="btFormAnnuler" type="button" value="Quitter"/>
                    </td>
                    
                </tr>
            </tbody>
        </table>
        
</div>
    <{if $this->transaction}>
        <div>
            <div id="wrapper"> Récépisé</div>   
            <div id="recap"> </div>
            
        </div>
    <{/if}>

<script>
    
     //annulation form
        $(".btFormAnnuler").click(function(){
            //check erreur type 
            var error="<{$this->error}>";
            switch(error){
                case "pwd":
                    //reset for dialog
                    try{
                         //$(".bzModale").remove();
                         $(".back ,.btFormAnnuler,#etape4,#etapeOpti1,#etape5").removeAttr("disabled");
                    }catch(error){

                    }
                break;
                case "pwdEmpty":
                    //reset for dialog
                    try{
                         //$(".bzModale").remove();
                        
                    }catch(error){

                    }
                break;
                case "chk":
                    //reset for dialog
                    try{
                         //$(".bzModale").remove();
                        
                    }catch(error){

                    }
                break;
                case "opti":
                    //reset for dialog
                    try{
                         //$(".bzModale").remove();
                         location.hash="transaction_getoffreopti";
                         $(window).trigger("hashchange");
                        
                    }catch(error){

                    }
                break;
                
                default:
                    //reset for dialog
                    try{
                         $(".bzModale").remove();
                         getContratsList();
                    }catch(error){

                    }
                break;
            }
            
             $("#dialogError").wijdialog("destroy");
             $("#dialogError").remove();
           
            
           
            return false;
            
        });
    
    $("#dialogError").wijdialog({
                            autoOpen:true,
                            modal: true,
                            captionButtons:{
                            pin: { visible: false },
                            refresh: { visible: false },
                            toggle: { visible: false },
                            minimize: { visible: false },
                            maximize: { visible: false },
                            close: { visible: false} 
                            },
                            title:"<{$this->title}>",
                            width:"500",
                            maxHeight:"600"
                        })
</script>