
<!--<div class="deconnection"><a href="/deconnexion">déconnection</a></div>-->
<div id="maskAcc"></div>
<div id="header" class="unselectable">
   
            <div id="identity">
                <p id="nom"><{$this->prenom}> <{$this->nom}></p>
                <p id="email"><{$this->identifiant}></p>  
                <div class="m_top" id="logout"><a id="logoutA" href="/deconnexion/">DECONNEXION</a></div>
            </div>
            <div id="menutop">
                <table id="Tab_menuTop">
                    
                    <tbody>
                        <tr >
                            <td class="border_null" style="border-right: none;min-height: 20px"></td>
                            <td> </td>
                            <td></td>
                            <td class="notifications n_click" code="messages" > 
                                <div class="notificationTxt"><{if isset($N_messages)}><{$N_messages}><{/if}></div> 
                               
                            </td>
<!--                            <td  class="notifications n_click" code="taches"  > 
                                <div class="notificationTxt"><{if isset($N_taches)}><{$N_taches}><{/if}></div> 
                                
                            </td>-->
                            <td  class="notifications n_click" code="documents" > 
                                <div class="notificationTxt"><{if isset($N_documents)}><{$N_documents}><{/if}></div>
                                
                            </td>
<!--                            <td> </td>-->
                            <td></td>
                        </tr>
                        <tr id="tr_menu">
                            <td id="acc" class="comun">
                                <div>Accueil</div>
                                <div id="pict_accueil"></div>
                            </td>
                            <td id="marches" class="comun">
<!--                                <div style="float:left">-->
                                <div>
                                    <div>Infos marches</div>
                                </div>
                                <div id="pict_marches"></div>
                                
                            </td>
                            <td id="offres" class="comun">
<!--                                <div style="float:left">-->
                                <div>
                                    <div>Offres</div>
                                </div>
                                <div id="pict_offres"></div>
                            </td>
                            <td class="comun n_click" code="messages">
                                <div>Messages</div>
                                <div id="pict_messages"></div>
                            </td>
<!-- peut etre ds le futur  <td class="comun n_click" code="taches">
                                <div>Taches</div>
                                <div id="pict_taches"></div>
                            </td>-->
                            <!--class n_click a était supprimée pour test a voir en fonction du comportement--->
                            <td class="comun " id="bzDocs" code="documents">
                                <div>Documents</div>
                                <div id="pict_documents"><a tille="test"/></div>
                            </td>
          
                            <td id="aide" class="comun">
                                <div>Aide</div>
                                <div id="pict_aide"></div>
                            </td>
                            <td id="compte" class="comun">
                                <div>Compte</div>
                                <div id="pict_compte"></div>
                            </td>
                            <td class="border_null" id="filtre" style="border-right: none;min-height: 20px">
                                
                            </td>
                            
                        </tr>
                    </tbody>
                </table>
                
                <div id="titreNav">Accueil</div>
                <div id="suTitreNav">CONTRATS</div>
                
                
                
                
            </div>
            
            <div id="canvas_siloNav" class="accueil">
<!--            mask transparent-->
            <img id="silo_mask" usemap="#zones" src="<{$this->serverUrl}>/styles/img/silo_mask.png" alt="mask" width="208" height="181"/>
            <map  name="zones">
                <area href="#" id="z_Tran" class="<{$this->acl['transaction']}>" title="Transaction" shape="poly" coords="118,55,191,45,207,53,207,116,135,126,135,98,119,90,119,65,118,55">
                <area href="#" id="z_exec" class="<{$this->acl['execution']}>" title="Exécution" shape="poly" coords="75,103,119,90,135,98,135,137,91,144,75,135,75,103">
                <area href="#" id="z_admin" class="<{$this->acl['administration']}>" title="Administration" shape="poly" coords="74,102,118,88,118,8,103,0,59,16,59,63,75,72,74,102">
                <area href="#" id="z_prospec" class="<{$this->acl['prospection']}>" title="Prospection" shape="poly" coords="0,71,0,135,14,142,72,134,73,72,57,63,0,71">
                
            </map> 
            
        </div>
        </div>
  <script>
      
 //change notifications
 //affichage notifications
   var displayNotifications=function(){
   
        $(".notificationTxt").each(function(evt){
        if($(this).text()!=0){
            $(this).parent().addClass("active");
        }else{
            $(this).parent().removeClass("active");
            $(this).text("");
        }
    })
   
   }
//check new notification polling technique
    function checkNotifications(){
    return;
        $.ajax({
            url:"/push/index/format/json",
            success:function(data){
               //data=JSON.parse(data);
               //ajouter lors du changement de base voir si fonctionne lorsque notification existe
               if(!data)return;
               $("#messages .notificationTxt").text(data.messages);
               
               $("#taches .notificationTxt").text(data.taches);
               $("#documents .notificationTxt").text(data.documents);
               displayNotifications();
               
               //if messagerie is open reload messagerie
            },
            error:function(error){

               clearInterval(timer);
            }
        })

    }
    var timer = setInterval("checkNotifications()", 5000);

    //attach event hash
    //gestion menu
    //silo nav 
    $(window).bind("menuToChange",function(event,_controller,_action){
       


        $("#t_menu td").removeClass("active");
        
        $("#t_menu td").each(function(i,e){



            if($(this).attr("rubrique")==_controller && $(this).attr("action")==_action){
                    
                    $(this).addClass("active");

            
            }

        })
        
        $("#canvas_siloNav").removeClass();
        $("#canvas_siloNav").addClass("snav_"+_controller);
        
    })
    

  </script>    