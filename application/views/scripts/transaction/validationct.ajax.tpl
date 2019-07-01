<div id="recapValid" class="trash" style="display:none;">
    <table style="width: 100%;margin-top: 7px;">
            <tbody>
                <tr>
                    <td style="text-align: left">
                        Votre contrat est enregistré.<br/>
                        Le numéro de transaction est le : <{$this->numtran}> <br/>
                        Vous pouvez télécharger le récépissé de votre transaction.<br/>
                        Un email de confirmation vient de vous être envoyé.<br/><br/>
                        <div style="text-align: center">
                        <input class="download" id="btDownloadRc" type="button" value="Télécharger"/>
                        <input class="btFormAnnuler" id="bt_quit" type="button" value="Quitter"/>
                        <input type="hidden" id="produit" name="pdt" value="<{$pdt}>"/>
                        </div>
                    </td> 
                </tr>
            </tbody>
        </table>
        
</div>

<script>
    var produit=$("#produit").val();
    $("#recapValid").wijdialog({
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
                        });
                        
    $("#btDownloadRc").click(function(){
        
        
        location.href="/telechargement/recepise/";
        setTimeout(function(){ $("#bt_quit").trigger("click");},20);
       

    });
    
    $("#bt_quit").click(function(){
        $("#recapValid").wijdialog("destroy");
        $("#recapValid").remove();
        $("#main").empty();
        $(".bzModale").remove();
        
        getContratsList(produit);

    })
    
    
</script>