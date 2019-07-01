<table id="T_Global" class="prospection wijmo-wijgrid-root wijmo-wijobserver-visibility wijmo-wijgrid-table" cellspacing="0" cellpadding="0" border="0"  style="border-collapse: separate;">
    <colgroup>
        <col style="width: 600px;">
        <col style="width: 138px;">
        <col style="width: 138px;">
        <col style="width: 138px;">
        <col style="width: 138px;">
        <col style="width: 138px;">
        <col style="width: 138px;">
        
    </colgroup>
    <thead>
        <tr class="wijmo-wijgrid-headerrow">
            <th class="wijgridth">Campagnes</th>
            <th class="wijgridth">Brut</th>
            <th class="wijgridth">Net</th>
            <th class="wijgridth">Surf</th>
            <th class="wijgridth">Prix</th>
            <th class="wijgridth">Date</th>
            <th class="wijgridth">Etat</th>
        </tr>
    </thead>
    <tbody>
        <{foreach from=$this->data->campagne item="camp" name="camp"}>
            <tr class="wijmo-wijgrid-row hasSubLevel level_0 camp" childsId="<{$smarty.foreach.camp.index}>">
                <td class="index_col">
                <div class="fleche-synthese"> </div><div class="titre-synth"><{$camp.nom}></div>
                </td><td></td><td></td><td></td><td></td><td></td><td></td>
                
            </tr>
             <{foreach from=$camp->culture item="cult" name="cult"}>
                
                <tr class=" wijmo-wijgrid-row hasSubLevel level_1 cultures" style="display:none" parentId="<{$smarty.foreach.camp.index}>" childsId="<{$smarty.foreach.camp.index}>_<{$smarty.foreach.cult.index}>">
                    <td class="index_col"><div class="fleche-synthese"> </div><div class="titre-synth"><{$cult.nom}></div></td><td><{if $cult.brut!="" && $cult.brut!="0.000"}><{$cult.brut}> t<{/if}></td><td><{if $cult.net!="" && $cult.net!="0.000"}><{$cult.net}> t<{/if}></td><td><{if $cult.surf!="" && $cult.surf!="0.00"}><{$cult.surf}> ha<{/if}></td><td><{$cult.px}></td><td></td><td></td>
                </tr>
                <{foreach from=$cult->structure item="struct" name="struct"}>
                    <tr class="wijmo-wijgrid-row hasSubLevel level_2 structures" style="display:none" parentId="<{$smarty.foreach.camp.index}>_<{$smarty.foreach.cult.index}>" childsId="<{$smarty.foreach.camp.index}>_<{$smarty.foreach.cult.index}>_<{$smarty.foreach.struct.index}>">
                        <td class="index_col"><div class="fleche-synthese"> </div><div class="titre-synth"><{$struct.nom}></div></td><td><{if $struct.brut!="" && $struct.brut!="0.000"}><{$struct.brut}>t<{/if}></td><td><{if $struct.net!="" && $struct.net!="0.000"}><{$struct.net}> t<{/if}></td><td><{if $struct.surf!="" && $struct.surf!="0.00"}><{$struct.surf}> ha<{/if}></td><td><{$struct.px}></td><td></td><td></td>
                    </tr>
                    
                    
                    <{if $struct->contrats}>
                        <{foreach from=$struct->contrats item="contrats" name="contrats"}>
                            <tr class="wijmo-wijgrid-row hasSubLevel level_3  contrats" style="display:none" parentId="<{$smarty.foreach.camp.index}>_<{$smarty.foreach.cult.index}>_<{$smarty.foreach.struct.index}>" childsId="ct_<{$smarty.foreach.camp.index}>_<{$smarty.foreach.cult.index}>_<{$smarty.foreach.struct.index}>_<{$smarty.foreach.contrats.index}>">
                                <td class="index_col"><div class="fleche-synthese"> </div><div class="titre-synth"> <{$contrats.numct}></div></td><td><{if $contrats.brut!="" && $contrats.brut!="0.000"}><{$contrats.brut}>t<{/if}></td><td><{if $contrats.net!="" && $contrats.net!="0.000"}><{$contrats.net}> t<{/if}></td><td><{if $contrats.surf!="" && $contrats.surf!="0.00"}><{$contrats.surf}> ha<{/if}></td><td><{$contrats.px}></td><td></td><td></td>
                            </tr>
                            
                            <{foreach from=$contrats->ct item="ct" name="ct"}>
                                <tr class="wijmo-wijgrid-row hasSubLevel level_4  contrat" style="display:none" parentId="ct_<{$smarty.foreach.camp.index}>_<{$smarty.foreach.cult.index}>_<{$smarty.foreach.struct.index}>_<{$smarty.foreach.contrats.index}>">
                                    <td class="index_col"> <{$ct.numct}></td><td><{if $ct.brut!="" && $ct.brut!="0.000"}><{$ct.brut}> t<{/if}></td><td><{if $ct.net!="" && $ct.net!="0.000"}><{$ct.net}> t<{/if}></td><td><{if $ct.surf!="" && $ct.surf!="0.00"}><{$ct.surf}> ha<{/if}> </td><td><{$ct.px}></td><td><{$ct.date}></td><td><{$ct.etat}></td>
                                </tr>
                            <{/foreach}>
                            
                        <{/foreach}>
                    <{/if}>
                    
                <{/foreach}>      
             <{/foreach}>  
        <{/foreach}>
    </tbody>
</table>

<script>
    $(".hasSubLevel").click(function(e){
        
        
        
       //$( e.target ).toggleClass( "fleche-synthese-active" );
        
        var childsIndex=$(this).attr("childsId");
        //longeur de

        if(!$(this).hasClass("opened")){
            //open
            
            $(this).toggleClass("opened");
            $(this).nextAll().filter(function(){
                //if(childsIndex==$(this).attr("parentId")) $(this).toggleClass("opened");
               
                return childsIndex==$(this).attr("parentId") 
            
            }).css("display","table-row");
            
        }else{
           
            //close
           
            $(this).toggleClass("opened");
            // it's first parent ex 13
            if(!$(this).attr("parentId")){
                
                var pattern=eval('/(^'+childsIndex+')|^[a-z]*(_'+childsIndex+')/');
                
                $(this).nextAll().filter(function(e){
 
                    if($(this).attr("parentId")){
                       
                        //ferme les ligne parent 
                        if($(this).hasClass("opened")) $(this).toggleClass("opened");
                       
                        return $(this).attr("parentId").match(pattern);
                    }else{
                        
                        //ferme les lignes enfant
                        
                        return false ;
                    }
                
                }).css("display","none");
            }else{
                
                
                 //lorsque ce n'est pas la racine 
                var pattern=eval('/(^'+childsIndex+')|^[a-z]*(_'+childsIndex+')/');
               
                if($(this).hasClass("opened")) $(this).toggleClass("opened");
                $(this).nextAll().each(function(x,el){
                    
                    if($(this).attr("parentId") && $(this).attr("parentId").match(pattern)){
                         $(this).css("display","none");
                    }else{
                         
                       return false
                    }
                
                })
            } 
        }
        
        
        
        
        
        
    })
    
    $("#maskAcc").css("display","none");
    $("#preloader").css("display","none");
    
</script>