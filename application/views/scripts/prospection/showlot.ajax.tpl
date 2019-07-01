
<form id="formModLot" class="form" name="formModLot" method="post" action="/prospection/validateferme/">
    <div class="bzHeader"><span>Formulaire de modification lot</span></div>
    <input type=hidden name="update" value="1"/>
    <input type=hidden name="idLot" value="<{$this->idLot}>"/>
    
    <table class="addLot"  id="tabLotFormcontent">
        <tbody>
            <tr>
                <td>
                    <div class="wraperLabel">
                   <label id="nomLot">Nom</label>
                    </div>
                </td>
                <td>
                    <input type="text" id='lib' name="lib" value="<{$formLotXml->lot['lib']}>"/> 
                </td>
                <td colspan="2">
                    <div class="wraperLabel">
                        <label id="camp">Campagnes</label>
                    </div>
                    <ul class="listform" id='listCamp'>
                        <li>
                            <input class="radioCamp" type="radio" name="camp" checked='checked' campec="<{$formLotXml->campagnes->campagne.campec}>" disabled="disabled" value="<{$formLotXml->campagnes->campagne.camp}>"><{$formLotXml->campagnes->campagne.camp}></input>
                        </li>
                    </ul>
                </td>    
            </tr>
            <tr>
                <td>
                    <div class="wraperLabel">
                        <label id="cult">Cultures</label>
                    </div>
                    <ul class="listform" id="listCult">
                    <{foreach from=$formLotXml->campagnes item=campagnes}>
                        <{foreach from=$campagnes->campagne  item=campagne name="lescampagnes"}>
                            <{if !empty($campagne.checked)}>
                                <{foreach from=$campagne->culture item=culture name="lescultures"}>
                                        <li>
                                            <input class="radioCult" type="radio" name="cult"  disabled="disabled" <{if $culture.checked==1}>checked='checked'<{/if}> camptabindex='<{$smarty.foreach.lescampagnes.index}>' culttabindex="<{$smarty.foreach.lescultures.index}>"   value="<{$culture.clecu}>"><{$culture.lib}></input>
                                            <input type=hidden name="cult" value="<{$culture.clecu}>"/>
                                        </li>
                                <{/foreach}>
                            <{/if}>    
                       <{/foreach}>
                    <{/foreach}>
                    </ul>
                </td>
                <td>
                    <div class="wraperLabel">
                    <label id="txtQte">Quantité</label>
                    </div>
                    <div class='qte I_text'>
                        <div id="tabQa">
                                <ul>
                                    <li class="ongletSous"><a  href="#tabs-1">Poids</a></li>
                                    <li class="ongletSous"><a  href="#tabs-2">Surface</a></li>
                                </ul>
                                <div id="tabs-1">
                                    <label>Poids (t)</label>
                                    <input class="In_text" name="poid" id="poid" idcult="<{$formLotXml->lot['clecu']}>" type="text" value="<{if $formLotXml->lot['qte']>0 }><{$formLotXml->lot['qte']}><{/if}>"/>
                                </div>
                                <div id="tabs-2">
                                    <label id="txtSurf">Surface (ha)</label>
                                    <input  class="In_text" name="surface" id="surface" idcult="<{$formLotXml->lot['clecu']}>" type="text" value="<{if $formLotXml->lot['ha']>0 }><{$formLotXml->lot['ha']}><{/if}>"/>
                                    <br/>
                                    <label class="surface detail" id="txtR">Rendement (qx/ha)</label>
                                    <input class="surface detail In_text" id="rendement" name="rendement" idcult="<{$formLotXml->lot['clecu']}>" type="text" value="<{if $formLotXml->lot['rend']>0 }><{$formLotXml->lot['rend']}><{/if}>"/>
                                    <br/>
                                    <label class="surface detail" id="txtPde">Poids estimé (t)</label>
                                    <input class="surface detail In_text" id="poidEst" name="poidEst" idcult="<{$formLotXml->lot['clecu']}>" type="text" readonly="readonly" value="<{if $formLotXml->lot['valeur']>0 }><{$formLotXml->lot['valeur']}><{/if}>"/>
                                </div>
<!--                        <br/>
                        <input id="btInit" type="reset" value="réinitialiser"/>-->
                    </div>
               </td>
               <td style="width:150px">
                       <div class="wraperLabel">
                            <label id="txtQual">Types</label>
                       </div>
                       <div class="type I_text" style="padding-top: 9px">
                            <div class="typeList" id="selectType">
                                <select id="typeList" name="typeList" style="width:100%">
                                    <option value=0 selected>aucun</option>
                                    <{foreach from=$formLotXml->campagnes->campagne->culture item=culture}>
               
                                                <{foreach from=$culture->type item=type}>
                                                    <{if $type.checked=="1"}>
                                                        <option value="<{$type.id}>" selected><{$type.lib}></option>
                                                    <{else}>
                                                        <option value="<{$type.id}>" ><{$type.lib}></option>
                                                    <{/if}>
                                                <{/foreach}>
                                              
                                       
                                    <{/foreach}>
                                </select>
                            </div>
                        </div>
                   </td>
                  <td>
                    <div class="qualites">
                        <div class="wraperLabel">
                            <label id="txtQual">Moyenne des qualités</label>
                        </div>
                        <div class="qualites I_text">
                        <div class="criteres">
                            <ul class="listform" id="listQua">
                                <{foreach from=$formLotXml->anamoy item=analyses}>
                                        
                                        <{foreach from=$analyses item=qualite}>
                                        <li>
                                            <label  name="code"><{$qualite.code}></label>
                                            <label  name="moy">  <{$qualite.valeur}></label>
                                        </li>
                                        <{/foreach}>
                                    
                                <{/foreach}>
                            </ul>
                        </div>
                    </div>
                    </div>
                            <input type="button" id="btCreateA" value="ajouter analyse"/>
                            <input type="button" id="btAffectA" value="affecter analyse" <{if !isset($formLotXml->analyses)}>disabled="disabled"<{/if}>/>
                </td>
            </tr>
            <tr>
                 <td class="W_dest">
                    <div class="wraperLabel">
                    <label id="txtDest">Destination</label>
                    </div>
                    <ul class="listform" id="listDest">
                        <{foreach from=$formLotXml->destinations item=destinations}>
                            <{foreach from=$destinations->destination item=destination}>
                                <li>
                                    <input type="radio" name="dest" <{if $destination.checked==1}>checked='checked'<{/if}>  value="<{$destination.idwdst}>"><{$destination.lib}></input>
                                </li>
                            <{/foreach}>
                        <{/foreach}>
                    </ul>
                </td>
                <td class="W_struc">
                    <div class="wraperLabel">
                    <label id="txtStruc">Structures</label>
                    </div>
                    <ul class="listform" id="listStruct">
                        <{foreach from=$formLotXml item=structures}>
                            <{foreach from=$structures->structure item=structure name="lesstructures"}>
                                <li>
                                    <input type="radio" class="radioStruct" name="struct" <{if $structure.checked==1}>checked='checked'<{/if}> structtabindex="<{$smarty.foreach.lesstructures.index}>"  value="<{$structure.idti}>"><{$structure.nom}></input>
                                </li>
                            <{/foreach}>
                        <{/foreach}>
                    </ul>
                </td>
                <td colspan="2">
                    <div class="wraperLabel">
                    <label id="txtExe">Execution</label>
                    </div>
                    <ul class="listform" id="listExe">
                    <{foreach from=$formLotXml item=executions}>
                            <{foreach from=$executions->execution item=execution}>
                                <li>
                                    <input type="radio" name="exe"  <{if $execution.checked==1}>checked='checked'<{/if}> value="<{$execution.idex}>"><{$execution.adr1}><{$execution.adr2}><{$execution.ville}></input>
                                </li>
                            <{/foreach}>
                    <{/foreach}>
                    </ul>
                </td> 
            </tr>
            <tr>
                <td colspan="3" style="text-align:center;padding-left:30%;height:40px">
                    <input class="btFormAddLot" id="btFormAnnuler"  type="button" value="Annuler"/>
                    <input class="btFormAddLot" id="btFormValider"  type="submit" value="Valider"/> 
                    
                </td>
            </tr>
        
    </tbody>
    </table>   
</form>

<div class="popup" id="dialogAffec" class="trash" style="display:none">
    <form>
        <table id="tabAnalysesAffect">
            <thead>
                <tr>
                    <th id="columSelect" class="wijgridth">Selection</th>
                    <th id="columNom" class="wijgridth" width="50px">nom</th>
                    <th id="columId" class="wijgridth" width="50px">Id</th>
                    <th id="columAnalyse" class="wijgridth">Analyses</th>
                    <th class="wijgridth"></th>
                </tr>
            </thead>
            <tbody>
                <!--id du lot--->
                <input type="hidden" name="idLot" value="<{$formLotXml->lot.id}>"/>
                <{foreach from=$formLotXml->analyses item=analyses}>
                        <{foreach from=$analyses->analyse item=analyse name="mesana"}>
                        <{$analyses->analyse.foreach.mesana.index}>
                        <{if $analyses->analyse.foreach.mesana.index % 2 == 0}>
                            <tr class="wijmo-wijgrid-row">
                        <{else}>  
                            <tr class="wijmo-wijgrid-alternatingrow">
                        <{/if}>
                    <td>
                            <input class="selectionAttente" idLot="<{$formLotXml->lot.id}>"  type="checkbox"  name="selectedAnalyses[][<{$analyse.idanalyse}>]" <{if $analyse.checked=="1"}>checked='checked'<{/if}> value="<{$analyse.idanalyse}>"/>
                        </td>
                        <td>
                            <{$analyse.nom}>
                        </td>
                        <td>
                            <{$analyse.idanalyse}>
                        </td>
                        <td id="<{$analyse.idanalyse}>">
                                    
                            <ul>
                                <{foreach from=$analyse item=qualite}>
                                <li>
                                    <label  name="code"><{$qualite.code}></label>
                                    <label  name="valeur"><{$qualite.valeur}></label>
                                    
                                </li>
                                <{/foreach}>
                            </ul>
                        </td>
                        <td>
                            <{if $analyse.prod==1}>
                                <{if $analyse.linked==1}>
                                    
                                    <label style="color:red">Analyses déjà liées</label>
                               <{else}>
                                    <input class="btMod" idAna="<{$analyse.idanalyse}>" idLot="<{$formLotXml->lot.id}>" type="button" value="modifier"/>
                                    <input class="btSupAna" idAna="<{$analyse.idanalyse}>" idLot="<{$formLotXml->lot.id}>" type="button" value="supprimer"/>
                                    
                                    
                                <{/if}>   
                            <{else}>
                                <img alt="bzA" src="/images/metier/bzAna.png"/>
                            <{/if}>    
                        </td>
                    </tr>
                    <{/foreach}>
                <{/foreach}>
            </tbody>
        </table>
        <!--<input type="button" id="valideAffect" value="valider"/>-->
       
        </form>
            <br/><br/>
            <div style="width:100%;text-align:center">
                <input id="btCloseAffect" type="button"  value="fermer"/>
            </div>
</div>
        
<div class="popup" id="dialogCreate" class="trash" style="display:none">
    <div class="criteres">
        <form name="formCreateAnal" id="formCreateAnal" methode="post" action="/prospection/createanalyse/format/json">  
        <div style="width:280px">
             <ul class="listform" id="listQua">
               <{foreach from=$formLotXml->campagnes item=campagnes}>
                <{foreach from=$campagnes->campagne item=campagne}>
                    <{foreach from=$campagne->culture item=culture}>
                        <{foreach from=$culture->critere item=critere}>
                            <li>
                                <label  name="code"><{$critere.code}></label>
                                <input class="critValues" type="text" name="criteres[<{$critere.idcc}>]" value=""/>
                                <input type="hidden" name="id"  value="<{$formLotXml->lot['id']}>"/>
                                <input type="hidden" name="lib"  value="<{$formLotXml->lot['lib']}>"/>
                            </li>
                        <{/foreach}>
                    <{/foreach}>
                   <{/foreach}>
                <{/foreach}>
            </ul>
        </div>
        <div style="width:100%;text-align:center">
             <input id="btCloseCreate" type="button"  value="annuler" style="width:110px"/>   
             <input type="submit" id="btCreate" value="valider" style="width:110px"/>
        </div>
      </form> 
    </div>
 
</div>        
<script>
    //clear function
    function makeDataGrid(){};
    // create modale effect
    $('body').append("<div class='bzModale'></div>");
    $(".bzModale").css("height",$(document).height());
    $(".bzModale").css("width",$(document).width());
    $("#canvas_siloNav").css("display","none");
    // collapse le filtre si besoin
    try{
        if($("#D_filter").css("display")=="block"){

            $("#D_filter").wijdialog("toggle");
            $("#D_filter").wijdialog({disabled:true});
        }
        $("#D_filter").wijdialog({disabled:true});
    }catch(error){
    
    }
    var formData=<{$formData}>;

 
        //function mise a jour  qualité moyenne et liste analyse affectées
        /**
         *@param result resultat a traiter
         *@param obj dialog objet   
         */    
        function updateListQuaLink(result){
       

        
                   var idLot=result.lots.lot['@attributes'].id;
                   //if(result.lots.anamoy=="undefined") return;
                   //flag pour presence anamoy    
                   hasAnamoy=true;  
                   var anamoy=result.lots.anamoy;
                   //cas ou aucune analyse n'as eté affecté :anamoy n'est pas retourné 
                   if(typeof(anamoy)=="undefined"){
                            hasAnamoy=false;
                            //on vide la liste il n'y as pas de moyenne
                            $("#listQua").html("");    
                                
                   }  
                   if(hasAnamoy){
                       
                   var qualites=anamoy.qualite;
                       
                   //if convertion en tab    
                    if(!isArray(qualites)){
                        //alert("isNot an array anamoy qualite");
                        qualites=convertToArray(qualites);
                    }   
                   

                            //clear liste
                            $("#listQua").empty();
                            //update analyse moyenne   
                            var li="";   
                            $.each(qualites,function(k,v){
                               
                                $.each(v,function(a,b){

                                    li+='<li><label name="code">'+b.code+'</label><label name="moy">'+b.valeur+'</label></li>';  
                                })
                            })

                                $("#listQua").html(li);
                                    
                           }         
                            //update analyse liées
                            analyses=result.lots.analyses;
                            
                            //console.log("analyses",analyses)

                            if(!analyses) {
                                $("#btAffectA").attr("disabled","disabled");
                                $("#tabAnalysesAffect tbody").empty();
                                return;    
                            }else{$("#btAffectA").removeAttr('disabled')};
                            
                            //probleme analyses here
                             
                            body='';
                                
                            //peuple analyse
                            $.each(analyses,function(i,analyses){
                            
                                //check if tab
                                if(!isArray(analyses)){
                                    //alert("isNot an array analyses");
                                    analyses=convertToArray(analyses);
                                }
                                //console.log("analyses",analyses);
                                $.each(analyses,function(a,analyse){
                                
                                   
                                   //console.log("analyse",analyse);
                                    body+='<tr>';
                                    
                                    $.each(analyse,function(u,value){
                                        
                                       checked=value.checked=="1"?'checked="checked"':"";
                                       idAnalyse= value.idanalyse;
                                       nom=value.nom;
                                       isProd=value.prod;
                                       isLinked=value.linked;    
                                         
                                    })
                                    body+='<td><input class="selectionAttente" type="checkbox" name="selectedAnalyses[]" '+checked+' value="'+idAnalyse+'" idlot="'+idLot+'"/></td>';
                                    body+='<td>'+nom+'</td>';
                                    body+='<td>'+idAnalyse+'</td>';
                                    body+='<td><ul>';
                                    
                                    
                                    
                                    if(!isArray(analyse)){
                                    
                                        analyse=convertToArray(analyse);
                                    }
                                    

                                    //console.log("analyse2",analyse);
                                    $.each(analyse,function(i,ana){
                                        if(ana.qualite){
                                            $.each(ana.qualite,function(r,qualite){
                                               
                                                $.each(qualite,function(s,t){
                                                   valeur=t.valeur?t.valeur:" ";
                                                   body+='<li><label  name="code">'+t.code+'</label><label  name="valeur"> '+valeur+' </label></li>';

                                                })  
                                            })
                                        
                                        }

                                    })
                                        
                                    body+='</ul></td>';
                                    
                                    if(isProd=="1"){
                                        if(isLinked=="1"){
                                            body+='<td>';
                                            body+='<label style="color:red">Analyses déjà liées</label>';
                                            body+='</td>';    
                                        }else{
                                            body+='<td>';   
                                            body+='<input class="btMod" idAna="'+idAnalyse+'" idLot="'+idLot+'" type="button" value="modifier"/>';
                                            body+='<input class="btSupAna" idAna="'+idAnalyse+'" idLot="'+idLot+'" type="button" value="supprimer"/>';    
                                            body+='</td>';
                                        }    
                                    }else{
                                        body+='<td>';   
                                        body+='<img alt="bzA" src="/images/metier/bzAna.png"/>';
                                        body+='</td>'
                                    }    
                                    body+='</tr>';    
                                })
                                
                            });
                            
                            $("#tabAnalysesAffect tbody").empty();
                            $("#tabAnalysesAffect tbody").html(body);
                            $(".btSupAna").bind("click",function(evt){deleteAna(evt)});
                            $(".btMod").bind("click",function(evt){modAna(evt)});    
                            $(".selectionAttente").bind("change",function(evt){linked(evt)});    
                           //success
                           //alert("analyse enregistré avec succès");
                           
   
        }//fin updateListQuaLink
        
        
       // disable champs surface 
       $('.surface.detail').attr("disabled","disabled");
       $('#surface').focus(function(){
           $('#poid').val("");
           $('.surface.detail').removeAttr('disabled');
           //verifie si rendement est remplis
           if( $('#rendement').val().length>0){
                   $('#surface').keyup( function() {
                        calculPest();
                    } );  
            }   
              
        })
       
       $('#rendement').focus(function(){

           //verifie si surface est remplis
           if( $('#surface').val().length>0){
                
                   $('#rendement').keyup( function() {
                        calculPest();
                    } );
            }   
        })
            
       $('#poid').focus(function(){
           
           //vide les champs rendement et surface
           $('#rendement').val("");
           $('#surface').val("");   
           $('#poidEst').val(""); 
           $('.surface.detail').attr("disabled","disabled");
 
        })
            
        
        //check le les champ pour donner le focus
           
        if(typeof($('#poid').val())=='undefined' || !$('#poid').val()){$('#surface').focus();calculPest();}else{$('#poid').focus();$('#poid').focus()}    
            
        
           
        var idCamp
     
                function changeStruc(){
                
                    $(".radioStruct").click(function(e){
                         
                        indexStruct=$(e.target).attr("structtabindex");
                     
                        structure=formData['lots']['structures']['structure'][indexStruct];

                        //remove les champs input
                            $('#listExe ').empty();

                            $.each(structure['execution'],function(c,d){
                            if(d['@attributes']){
                                lieu=d['@attributes']['adr1']+d['@attributes']['adr2']+d['@attributes']['ville'];
                                value= d['@attributes']['idex'];    
                                }else{
                                lieu=d.adr1+d.adr2+d.ville;
                                value= d.idex;   
                            }

                            $('#listExe').append('<li><input type="radio" name=exe value="'+value+'">'+lieu+'</input> </li>');    
                        })      
                                
                    });
                } 
                
                function calculPest(){
                    //init var
                     rendement=null;
                     surface=null;    
                         
                     if($('#rendement').val().length>0){  
                        rendement= $('#rendement').val();
                        rendement= rendement.replace(",",".");   
                        rendement= parseFloat(rendement);
                     }    
                     
                     if($('#surface').val().length>0){
                        surface=$('#surface').val();
                        surface=surface.replace(",",".");     
                        surface= parseFloat(surface);
                     }


                    //check type 
                    if(typeof rendement=="number" && typeof surface=="number"){
                           $('#poidEst').val(parseFloat((surface*rendement)/10).toFixed(2));

                     }
   
                }
                    
                /*function convertVirgule(obj){
                    obj.keyup(function(o){
                                    if(o.keyCode==188){

                                    str=$(o.target).val();

                                    str= str.replace(',','.');

                                    $(o.target).val(str);
                                    }    
                            })
                }*/
                 //check if is numeric 
                /*function IsNumeric(val) {

                    if (!$.isNumeric(val)) {
                        return false;
                    }
                    return true;
                }*/
                    
                
    
                //init function    
                //changeCult();
                changeStruc();
                //check virgule
                $('.qte').each(function(i,e){convertVirgule($(e))})
   
                $('.critValues').each(function(i,e){convertVirgule($(e))});
                    
                 
                    
            
   //validation 
         //annulation
                $('#btFormAnnuler').click(function(e){
                    // remove la div pour eviter conflits
                    $("#dialogCreate").remove();
                    $(".bzModale").remove();
                    $("#preloader").css("display","block");
                    
                    location.hash="prospection_ferme";
                });
         //valider
                //validation du formulaire
               // $('#btFormValider').click(function(e){
              $("#formModLot").on('submit',function(evt){
              
                        evt.preventDefault();
                    //validation du formulaire
                     //lib   
                     if($('#lib').val()==""){
                             alert("nom du lot obligatoire");
                             return;
                     }
                     
                     //check numerique value 
                    if(!$.isNumeric($('#poid').val()) && $('#poidEst').val()=="" ){
                        alert("Poids   doit être une valeure numérique non nulle." )
                    }
                    
                    if(!$.isNumeric($('#poidEst').val()) && $('#poid').val()=="" ){
                        alert("Surface   doit être une valeure numérique non nulle." )
                    }
                        
                    
                     //poid ou surface
                     if(($('#poidEst').val()=="" || $('#poidEst').val()==0) && ($('#poid').val()=="" || $('#poid').val()==0)){
                         alert("Vous devez entrer un poids ou une surface et un rendement non nul. ")
                         return;
                     }
                     //validation de type 
                      /**
                       *@todo vercifier lettre dans form
                       *faire verification de
                       */
                      //verification des champs si num
                       
                           // if(!inputIsNumeric($(".checkValue"),true))  return false;
                          
                           //if(!$.isNumeric($("#poid").val()) && !$.isNumeric($("#poidEst").val()))  return false;
                           
                     
                      $.ajax({
                        url:"/prospection/validateferme/format/json",
                        data:$(this).serialize(),
                        success:function(data){
                            //console.log("data",data.error)
if(data.error) alert("error");
                            $(".bzModale").remove();
                             $("#preloader").css("display","block");
                            if(!parseInt(data)){
                                location.hash="prospection_ferme";
                            }
                        },
                        error:function(xhr, ajaxOptions, thrownError){
                           /*console.log("xhr",xhr);
                           console.log("ajaxOptions",ajaxOptions);
                           console.log("thrownError",thrownError);*/
                           alert("une erreur est survenue, il est possible que votre modification ne soit pas prise en compte.");
                        }
                  
                      })
                      
                      return false;
                      
                });

                  
           //handle dialog
           //affecte    
           $("#btAffectA").click(function(evt){
                //dialog analyse en affectation
               $("#dialogAffec").wijdialog({
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
                    title:"Affecter une analyse",
                    width:"500",
                    maxHeight:"600",
                    close:function(){$("#dialogAffec").wijdialog("destroy")},
                    open:function(e){
                            var dialog=$(e.target);
                                if(!$(".sc-bt-dialog-close").length){
                                     $(e.target).parent().find(".ui-dialog-titlebar").append("<span class='sc-bt-dialog-close' style='cursor:pointer;position:absolute;right:5px;' ></div>");
                                            $(".sc-bt-dialog-close").bind("click",function(e){
                                                dialog.wijdialog('close');
                                            })
                                 }
                        }
                    }); 
                
                
            })
            
            // affect click 
               $("#btCloseCreate").bind("click",function(e){      
                   $("#dialogCreate").wijdialog("close");
                   $("#dialogCreate").wijdialog("destroy");
                   
                }) 
         
           //create    
           $("#btCreateA").click(function(evt){
           
                //dialog analyse create
               $("#dialogCreate").wijdialog({
                    autoOpen:true,
                    modal: true,
                    captionButtons:{pin: { visible: false },
                    refresh: { visible: false },
                    toggle: { visible: false },
                    minimize: { visible: false },
                    maximize: { visible: false },
                    close: { visible: false } },
                    title:"Créer une  analyse",
                    width:"500",
                    maxHeight:"600"
               }); 
              
           
                //$("#dialogCreate").wijdialog("open");
            })   
            //envois formulaire analyse add       
            $('#formCreateAnal').submit(

                function(evt){
                    
                        
                        evt.preventDefault();
                         
                        //verification des champs si num
                        if(!$.isNumeric($(".critValues").val()))  return false; 
                            
                        //serialisation
                         mydata= $("#formCreateAnal").serialize();
                         
                         //action    
                         url=$("#formCreateAnal").attr('action');
                         $.ajax({
                         url:url,
                         data:mydata,
                         success:function(result){
                         //console.log("result data",result);
                            //alert("success")
                            //switch erreur
                            /*if(!checkError(result)){  
                                    alert("erreur");
                                   $("#dialogCreate").wijdialog("close");
                                   $("#dialogCreate").wijdialog("destroy");
                                   return;    
                            }; */

                            if(result.error){
                            
                                try{
                                    $("#dialogCreate").wijdialog("close");
                                    $("#dialogAffec").wijdialog("close");
                                }catch(error){}
                                alert(result.error);
                                location.hash="index_index";
                                $(window).trigger("hashchange");
                                return false;    
                            }
                           
                            //replace analyses in json data formData.lots.analyses.analyse
                            formData.lots.analyses=result.lots.analyses;
                             
                            //update 
                            updateListQuaLink(result);
  
                            $("#dialogCreate").wijdialog("close");    
                        }
                    }) //fin ajax
                });//fin submit
                
                
                    
             
           
           
           
           //check uncheck analyses
           function linked(evt){
               idAna=$(evt.target).attr("value");
               idLot=$(evt.target).attr('idLot');
               checked= $(evt.target).attr('checked')=="checked"?1:0;   
               $.get("/prospection/modifyanalyse/format/json",{idAna:idAna,idLot:idLot,checked:checked},function(result){
                  
                  //update liste
                     
                  //switch error
                   if(result.error){  
                                
                            try{
                                $("#dialogMod").wijdialog("close");
                                $("#dialogAffec").wijdialog("close");
                            }catch(error){}
                            alert(result.error);
                            location.hash="index_index";
                            $(window).trigger("hashchange");
                    }else{
                        try{        
                            updateListQuaLink(result);
                            alert("Analyse modifiée avec succès"); 
                        }catch(error){
                            //$("#dialogAffec").wijdialog("close");
                            alert(error);
                            alert("une erreur est survenue");    
                        }    
                          //close dialog
                          //$("#dialogAffec").wijdialog("close");
                               
                    };  
                      
              })

           };
               
          // valide modify analyse     
          $(".btMod").click(function(evt){modAna(evt)});

           //supp
           function deleteAna(evt){
               
               idAna=$(evt.target).attr('idAna');
               idLot=$(evt.target).attr('idLot');
   
              $.get("/prospection/supanalyse/format/json",{idAna:idAna,idLot:idLot},
                    function(result){
                    //update liste
 
                     if(result.error){
                            try{
                                $("#dialogMod").wijdialog("close");
                                $("#dialogAffec").wijdialog("close");
                            }catch(error){}
                            alert(result.error);
                     }else{
                 
                        try{        
                            updateListQuaLink(result);
                            alert("Analyse supprimée avec succès"); 
                        }catch(error){
                           $("#dialogAffec").wijdialog("close"); 
                             
                        }   
                    }
                     
                    //close dialog
                    try{
                      $("#dialogAffec").wijdialog("close");
                    }catch(error){}
                     
              })

           };
            //modAna
             function modAna(evt){
             //console.log("analyses",formData.lots.analyses);
             return;
            
                  $("#valideAffect").unbind("click");  
                  content='<div class="popup" id="dialogMod" class="trash"><form id="formModAna" method="post"  name="form_mod_analyse"><table><tbody>';
               
                  analyses= formData.lots.analyses;
                 
                  var tabCritRemplis=[];
                  $.each(analyses.analyse,function(k,v){
                             
                                $.each(v,function(a,b){
                                    //console.log("each qualite 0",b)
                                    /**
                                    * probleme id et idanalyse !=
                                    */
                                    if(b.idanalyse==$(evt.target).attr("idAna")){
                                        
                                        if(!isArray(v.qualite)){
                                           v.qualite=convertToArray(v.qualite);
                                        }
                                        
                                        $.each(v.qualite,function(c,d){
                                        
                                                //console.log("each qualite")
                                                                                                                                                     
                                                $.each(d,function(e,f){
                                                //console.log("f",f)
                                                    tabCritRemplis.push(f.code);


                                                    var valeur=f.valeur?f.valeur:"";
                                                    content+="<tr>"
                                                    content+='<td><label style="margin-right:5px">'+f.code+'</label></td>';
                                                    content+='<td><input type="text" class="crit" name="criteres['+f.id+']" value="'+valeur+'" style="float:right;width:150px"/></td>';
                                                    content+="</tr>"

                                                    
                                                })

                                            })
                                            //ajout des critere qui ne sont pas encore renseignés
                                            $.each(formData.lots.campagnes.campagne.culture.critere,function(a,b){
                                                

                                                
                                                if(tabCritRemplis.indexOf(b['@attributes'].code)==-1){
                                                
                                                    var valeur="";
                                                    content+="<tr>"
                                                    content+='<td><label style="margin-right:5px">'+b['@attributes'].code+'</label></td>';
                                                    content+='<td><input type="text" class="crit" name="criteres['+b['@attributes'].idcc+']" value="'+valeur+'" style="float:right;width:150px"/></td>';
                                                    content+="</tr>"
                                                }
                                                
                                                
                                                
                                    
                                            })        
                                            
                                    }// endif idana
                                    //li+='<li><label name="code">'+b.code+'</label><label name="moy">'+b.valeur+'</label></li>';
                                       
                                })                               
                            })
                 content+= '</tbody></table><div class="clear"></div>';         
                 content+='<input type="hidden" name="idLot" value="'+$(evt.target).attr("idLot")+'"/>'; 
                 content+='<input type="hidden" name="idAna" value="'+$(evt.target).attr("idAna")+'"/>';
                 content+='<div style="text-align:center">';
                 content+='<input id="btCloseDialogMod" style="margin-top:15px"  type="button" value="annuler" />';
                 content+='<input style="clear:both;margin-right:30px;margin-top:15px" type="button" id="valideAffect" value="valider"/>';
                 content+='</div>';
                 content+='</form></div>';               

                     
                  $("body").append(content);
                   
                   $("#btCloseDialogMod").bind("click",function(){      
                        $("#dialogMod").wijdialog("close");
                        $("#dialogMod").remove();    
                    });
                    
                 $("#valideAffect").bind( "click",function(){valiModAna()});
      
                  $("#dialogMod").wijdialog({
                        modal: true,
                        captionButtons:{
                            pin:{ visible: false },
                            refresh:{ visible: false },
                            toggle:{ visible: false },
                            minimize:{ visible: false },
                            maximize:{ visible: false },
                            close: {visible: false } 
                        },
                        title:"Modifier une  analyse"
                    })
                   try{    
                    $("#dialogMod").wijdialog("open");    
                   }catch(error){}
           }//fin modana  
           //check coma
           $('.inputQua').each(function(i,e){
            
                            convertVirgule($(e));
                      });
                          
                
           function valiModAna(){
               //check input
                   
                    //verification des champs si num
                   // if(!$.isNumeric($(".inputQua").val()))  return false;
                   var flagBreak=null;
                   $.each($(".crit"),function(i,e){

                            if($(e).val()!="" && !$.isNumeric($(e).val())){
                                alert("Vous devez entrer une valeur numérique.");
                                flagBreak=true;
                                return false;
                            }
                        
                   })
                   
                   if(flagBreak) return false;
        
                    //serialisation
                         mydata= $("#formModAna").serialize();
                           
                         //action    
                         url="/prospection/modifyanalyse/format/json";    

                         $.post(url,mydata,function(result){
                            //console.log("result",result);
                            //switch erreur
                            if(result.error){
                                try{
                                    $("#dialogMod").wijdialog("close");
                                    $("#dialogAffec").wijdialog("close");
                                }catch(error){}
                                alert(result.error);
                                location.hash="index_index";
                                $(window).trigger("hashchange");
                                };
                            try{        
                                    updateListQuaLink(result);
                                    alert("Analyse modifiée avec succès");
                                    $("#dialogMod").wijdialog("close");
                                    return;        
                                }catch(error){
                                    $("#dialogMod").wijdialog("close"); 
                                    alert("Une erreur s'est produite, votre modification n'est peut être pas prise en compte.");    
                                } 
                            
                        });       
                }
             //affecte function sup to click      
             $(".btSupAna").click(function(evt){deleteAna(evt)});
             $(".selectionAttente").change(function(evt){linked(evt)});    
             
            // ferme dialog affect
            $("#btCloseAffect").click(function(){
                try{ 
                    $("#dialogAffec").wijdialog("close");
                }catch(error){
            
                }
            })
            
            //tabs
             $("#tabQa").tabs();
           
          
            if(!parseInt($(".radioCamp").attr("campec"))){
                $("#tabQa").tabs({ active: 1 });
                $("#tabQa").tabs( "disable", 0 );
            }else{
                $("#tabQa").tabs( "enable" );
            }
            
            $("#tabQa").tabs();
           //console.log("campec",$(".radioCamp").attr("campec"))
          
            if(!parseInt($(".radioCamp").attr("campec"))){
                $("#tabQa").tabs({ active: 1 });
                $("#tabQa").tabs( "disable", 0 );
            }else{
                $("#tabQa").tabs( "enable" );
            }
            
            //scroll 
            window.scrollTo(0,0);   
    
</script>    
                        