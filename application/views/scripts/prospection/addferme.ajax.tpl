
    <form id="addLotForm" class="form " name="formAddLot" method="post" action="/prospection/validateferme/">
        <div class="bzHeader"><span>Formulaire d'ajout stock ferme</span></div>
        <span style="font-size: 8pt; position: relative; top: 3px;padding-left:8px">*Champs obligatoires</span>
        <table class="addLot" id="tabLotFormcontent">
            <tbody>
                <tr>
                    <td>
                        <div class="wraperLabel">
                            <label id="nomLot">Nom *</label>
                        </div>                  
                    </td>
                    <td>
                        <input type="text" id='lib' name="lib"/> 
                    </td>
                    <td colspan="2">
                        <div class="wraperLabel">
                            <label id="camp">Campagnes *</label>
                        </div>    
                        <ul class="listform" id='listCamp'>
                        <{foreach from=$formLotXml item=campagnes}>
                            <{foreach from=$campagnes->campagne item=campagne}>
                                <li>
                                    <input class="radioCamp" type="radio" name="camp" <{if $campagne.checked==1}>checked='checked'<{/if}> value="<{$campagne.camp}>"><{$campagne.camp}></input>
                                </li>
                            <{/foreach}>
                        <{/foreach}>
                        </ul>
                    </td>    
                </tr>
                <tr>
                    <td>
                        <div class="wraperLabel">
                            <label id="cult">Cultures *</label>
                        </div>
                        <ul class="listform" id="listCult">
                        <{foreach from=$formLotXml item=campagnes}>
                            <{foreach from=$campagnes->campagne  item=campagne name="lescampagnes"}>
                                <{if !empty($campagne.checked)}>
                                    <{foreach from=$campagne->culture item=culture name="lescultures"}>

                                            <li>
                                                <input class="radioCult" type="radio" name="cult"  camptabindex='<{$smarty.foreach.lescampagnes.index}>' culttabindex="<{$smarty.foreach.lescultures.index}>"   value="<{$culture.clecu}>"><{$culture.lib}></input>
                                            </li>
                                    <{/foreach}>
                                <{/if}>   
                            <{/foreach}>
                        <{/foreach}>
                        </ul>
                    </td>
                    <td>
                        <div class="wraperLabel">
                            <label id="txtQte">Quantité *</label>
                        </div>
                        <div class='qte I_text'>
                            <div id="tabQa">
                                <ul>
                                    <li class="ongletSous"><a  href="#tabs-1">Poids</a></li>
                                    <li class="ongletSous"><a  href="#tabs-2">Surface</a></li>
                                </ul>
                                <div id="tabs-1">
                                    <label>Poids (t)</label>
                                    <input class="In_text" name="poid" id="poid" idcult="" type="text" value=""/>
                                </div>
                                <div id="tabs-2">
                                    <label id="txtSurf">Surface (ha)</label>
                                    <input  class="In_text" name="surface" id="surface" idcult="" type="text" value=""/>
                                    <br/>
                                    <label class="surface detail" id="txtR">Rendement (qx/ha)</label>
                                    <input class="surface detail In_text" id="rendement" name="rendement" idcult="" type="text" value=""/>
                                    <br/>
                                    <label class="surface detail" id="txtPde">Poids estimé (t)</label>
                                    <input class="surface detail In_text" id="poidEst" name="poidEst" idcult="" type="text" readonly="readonly" value=""/>
                                </div>
                            </div>
                        </div>
                   </td>
                   <td style="width:150px">
                       <div class="wraperLabel">
                            <label id="txtQual">Types</label>
                       </div>
                       <div class="type I_text" style="padding-top: 9px">
                            <div class="typeList" id="selectType">
                            </div>
                        </div>
                   </td>
                   <td>
                       <div class="wraperLabel">
                        <label id="txtQual">Qualité</label>
                       </div>
                        <div class="qualites I_text">
                            <div class="criteres">
                            </div>
                        </div>
                    </td>

                </tr>
                <tr>
                     <td class="W_dest">
                        <div class="wraperLabel">
                            <label id="txtDest">Destination</label>
                        </div>    
                        <ul class="listform" id="listDest">
                            <{foreach from=$formLotXml item=destinations}>
                                <{foreach from=$destinations->destination item=destination}>
                                    <li>
                                        <input type="radio" name="dest"  value="<{$destination.idwdst}>"><{$destination.lib}></input>
                                    </li>
                                <{/foreach}>
                            <{/foreach}>
                        </ul>
                    </td>
                    <td class="W_struc">
                        <div class="wraperLabel">
                            <label id="txtStruc">Structures *</label>
                        </div>    
                        <ul class="listform" id="listStruct">
                            <{foreach from=$formLotXml item=structures}>
                                <{foreach from=$structures->structure item=structure name="lesstructures"}>
                                    <li>
                                        <input type="radio" class="radioStruct" name="struct" structtabindex="<{$smarty.foreach.lesstructures.index}>"  value="<{$structure.idti}>" <{if $structure.idti=="0" }> checked="checked"<{/if}>><{$structure.nom}></input>
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
                                        <input type="radio" name="exe"  value="<{$execution.idex}>"><{$execution.adr1}><{$execution.adr2}><{$execution.ville}></input>
                                    </li>
                                <{/foreach}>
                        <{/foreach}>
                        </ul>
                    </td> 
                </tr>
                <tr>
                    <td colspan="4" style="text-align:center;padding-left:30%;padding-right:30%;height:40px">
                        <input class="btFormAddLot" id="btFormAnnuler" style="float:left" type="button" value="Annuler"/>
                        <input class="btFormAddLot" id="btFormValider" style="float:right" type="button" value="Valider"/>
                    </td>
                </tr>

        </tbody>
        </table>    
    </form>

<script>
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
    
    $("#lib").focus();
    
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
 
        var idCamp
        //change camp
        $(".radioCamp").click(function(e){
        
               var camp = $(".radioCamp").first().val();
               var selectedCamp=$( ".radioCamp:checked" ).val();
                if(selectedCamp>camp){
                    $("#tabQa").tabs({ active: 1 });
                    $("#tabQa").tabs( "disable", 0 );
                }else{
                    $("#tabQa").tabs( "enable" );
                }
              
              //initialise qualites
              $(".criteres").empty();    
               
              campagne=formData['lots']['campagnes'];

               idCamp=$(e.target).attr("value"); 
                  
              $.each(campagne,function(i,e){

                   $.each(e,function(a,b){
                       
                        if(b['@attributes']['camp']==idCamp)
                        {
                           $("#listCult").empty();
                           $.each(b['culture'],function(c,d){
                               
                               if(d['@attributes']){
                                    value=d['@attributes']['clecu'];
                                    lib=d['@attributes']['lib'];    
                                }else{
                                    value=d.clecu;
                                    lib=d.lib;    
                            }
                                   $("#listCult").append('<li><input class="radioCult" type="radio" name="cult" camptabindex="'+a+'" culttabindex="'+c+'"  value="'+ value+'">'+lib+'</input></li>');
   
                           })    
                        }
                          
                   })

                })  
            //bind click
            $(".radioCult").bind('click',changeCult());
        })
            
            
            //change culture
             function changeCult(){   
                $(".radioCult").click(function(e){
                    
                     indexCult=$(e.target).attr("culttabindex");
                     indexCamp=$(e.target).attr("camptabindex"); 
                         
                     culture=formData['lots']['campagnes']['campagne'] [indexCamp]['culture'][indexCult];
                     //remove les champs input
                         $('.criteres ').empty();

                             
                      $.each(culture['critere'],function(c,d){
                          
                          //show quality 
                          if(d['@attributes']){
                                    code=d['@attributes']['code'];
                                    idcc=d['@attributes']['idcc'];    
                                }else{
                                    code=d.code;
                                    idcc=d.idcc;    
                            }
                          $('.criteres').append(code+ ':  <input type="text" class="In_text" name="criteres[]['+idcc+']" label="'+code+'" value="" /><br> ');    
                      })       
                     
                      $('.criteres').each(function(i,e){
            
                            convertVirgule($(e));
                      })
                      
                      // gestion types culture
                      $("#selectType").empty();
                      // create select html
                      
                      if(culture['type']){
                            
                          var type=culture['type'];
                          if(!isArray(type)){
                                type=convertToArray(type);
                          }

                          $("#selectType").append('<select id="typeList" name="typeList" style="width:100%"><option value=0>Aucun</option></select>');
                          $.each(type,function(a,b){
                                //console.log("b",b);
                                $("#typeList").append('<option value="'+b['@attributes']['id']+'">'+b['@attributes']['lib']+'</option>')

                          })
                      }
                      //$("#selectType").append($selectType);
                      
                      
                })
                
                
                }
                    
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
                    
                
                //init function    
                changeCult();
                changeStruc();
                //virgule pour qt
                $('.qte').each(function(i,e){convertVirgule($(e))})    
            
        //validation 
            //annulation
                $('#btFormAnnuler').click(function(e){


                    $(".bzModale").css("display","none");
                    location.hash="prospection_ferme";
                });
            //valider
                //validation du formulaire
                $('#btFormValider').click(function(e){
    
                    //validation du formaulaire
                     //lib   
                     if($('#lib').val()==""){
                             alert("Vous devez renseigner le nom du lot.");
                             return;
                     }
                        
                     //cult
                    if($('input[type=radio][name=cult]:checked').length<1){
                            alert("Vous devez sélectionner une culture.");
                            return;    
                        };
                        
                    //check numerique value 
                    if(!$.isNumeric($('#poid').val()) && $('#poidEst').val()=="" ){
                        //if($('#poid').val()=="" || !$.isNumeric($('#poid').val())){alert("Poids et rendement  doivent être une valeure numérique non nulle." );return;  }
                        alert("Poids   doit être une valeure numérique non nulle." )
                    }
                    
                    if(!$.isNumeric($('#poidEst').val()) && $('#poid').val()=="" ){
                        //if($('#poid').val()=="" || !$.isNumeric($('#poid').val())){alert("Poids et rendement  doivent être une valeure numérique non nulle." );return;  }
                        alert("Surface   doit être une valeure numérique non nulle." )
                    }
                        
                        
                     //poid ou surface
                     if(($('#poidEst').val()=="" || $('#poidEst').val()==0) && ($('#poid').val()=="" || $('#poid').val()==0)){
                         alert("Vous devez entrer un poids ou une surface et un rendement non nul. ")
                         return;
                     }
                     //validation de type 
                      
                      //pattern="/[0-9]/i";
                      //var pattern=new RegExp("[a-zA-Zéèàùâêîôûäëïöüç''\"\"#{}&!:;/?*$=)(-|]");   
                      
                      
                      
                     
                      //si rendement ou verifie les valeures
                     if($('#poid').val()=="" && $('#surface').val()==""){
                         if($('#rendement').val()=="" || !$.isNumeric($('#rendement').val())){alert("Rendement doit être une valeure numérique" );return;  }  
                         if($('#surface').val()=="" || !$.isNumeric($('#surface').val())){alert("Surface doit être une valeure numérique non nulle" );return;  }
                         //if($('#poid').val()=="" || !pattern.test($('#poid').val())){alert("Poids doit être une valeure numérique non nulle" );return;  }
                         if($('#poid').val()=="" || !$.isNumeric($('#poid').val())){alert("Poids doit être une valeure numérique non nulle" );return;  }
                         //
                     }
                     
                    
                     $.ajax({
                        url:"/prospection/validateferme/",
                        data:$('#addLotForm').serialize(),
                        success:function(data){
                            // console.log("data error",data.error)
                            if(data.error) alert(data.error);
                            $(".bzModale").css("display","none");
                            location.hash="prospection_ferme";
                            $(window).trigger("hashchange");
                        }

                    })
                    
                    _gaq.push(['_trackEvent', 'propsection', 'ferme_addLot','validation ajout lot']);
                    
                    //$('#addLotForm').submit();
                });
                
                
                $("#tabQa").tabs();
                
        
              //scroll 
              window.scrollTo(0,0);
            
     
</script>    
                        