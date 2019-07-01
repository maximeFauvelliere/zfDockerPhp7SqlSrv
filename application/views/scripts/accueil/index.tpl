<script>
    //  hashtag pour accueil
    location.hash="accueil";
    // vide sous titre 
    $("#suTitreNav").empty();
    controller="<{$this->controller}>";
    
    function makeDataGrid(){};
    
    try{
            $("#D_filter").wijdialog({disabled:false});
        }catch(error){
        
        }
    
   //affichage notifications
    displayNotifications();
    
    //creer le silo une fois le filtre open
    $(window).bind("filterOpen",function(){
  
});
    
$("#canvas_siloNav").css("display","none");

</script>

<div id="accueil" style=" width:1000px;height:650px;position: relative;left:-50px;top:50px;display:none">  
    <div id="admTxt" class="boxTxt unselectable" style="position:absolute; top:-12px; left:230px;">
            <a href="#" style="position:relative;top:-12px;left:-110px;">ADMINISTRATION</a>
            <{if $this->acl['administration']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:-213px;top:9px;display:none">
                    camp : <{$this->data->admin->camp}><br/>
                    <{foreach from=$this->data->admin->line item="item"}>
                        <{$item}><br/>
                    <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>
        <div id="proTxt" class="boxTxt unselectable" style="width: 100px;position:absolute; top:108px; left:155px;">
            <a href="#" style="position:relative;top:-12px;left:-110px;">PROSPECTION</a>
            <{if $this->acl['prospection']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:-253px;top:10px;display:none">
                    camp : <{$this->data->pro->camp}><br/>
                    <{foreach from=$this->data->pro->line item="item"}>
                        <{$item}><br/>
                    <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>


        <div id="exeTxt" class="boxTxt unselectable" style="width:280px;position:absolute; top:272px; left:85px;">
            <a href="#" style="position:relative;top:35px;left:-80px;">EXECUTION</a>
            <{if $this->acl['execution']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:-225px;top:55px;display:none">
                    camp : <{$this->data->exec->camp}><br/>
                    <{foreach from=$this->data->exec->line item="item"}>
                        <{$item}><br/>
                    <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>
        <div id="ctTxt" class="boxTxt unselectable" style="width:280px;position:absolute; top:390px; left:111px;">
            <a href="#" style="position:relative;top:-12px;left:-150px;"  <{if $this->data->contrats->qte !="0"}>nbct="nbct"<{/if}>>CONTRAT(S) A SIGNER </a>
            <{if $this->acl['contrats']=="M_active" && $this->acl['administration']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:-190px;top:10px;display:none">
                   <{foreach from=$this->data->contrats->qte item="item"}>
                        Vous avez <{$item}> contrat(s) à signer.<br/>
                    <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>
        <div id="offresTxt" class="boxTxt unselectable" style="height:180px;width:200px;position:absolute; top:340px; left:502px;">
            <a href="#" style="position:relative;top:169px;left:210px;">OFFRES BZ</a>
            <{if $this->acl['transaction']=="M_active" && $this->acl['offres']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:210px;top:190px;display:none;width:200px;">
                    Opportunité(s) de la semaine</br>
                    <{foreach from=$this->data->offres->line item="item"}>
                        <{$item}><br/>
                    <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>
        <div id="analysesTxt" class="boxTxt unselectable" style="height:15px;width:180px;position:absolute; top:310px; left:655px;">
            <a href="#" style="position:relative;top:5px;left:195px;" <{if $this->data->analyses->qte !="0"}>nbana="nbana"<{/if}>>ANALYSES</a>
            <{if $this->acl['analyses']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:195px;top:28px;display:none">
                    <{foreach from=$this->data->analyses->qte item="item"}>
                        Vous avez <{$item}> analyse(s)<br/> en attente d'affectation.<br/>
                    <{/foreach}>
                </div>
             <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>
        <div id="infosTxt" class="boxTxt unselectable" style="height:45px;width:110px;position:absolute; top:170px; left:735px;">
            <a href="#" style="position:relative;top:-10px;left:120px;">INFOS MARCHES</a>
            <{if $this->acl['infosmarches']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:120px;top:12px;display:none">
                    <{foreach from=$this->data->infos->line item="item"}>
                        <{$item}><br/>
                    <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
            
        </div>
        <div id="tranTxt" class="boxTxt unselectable" style="height:75px;width:105px;position:absolute; top:47px; left:500px;">
            <a href="#" style="position:relative;top:-10px;left:108px;">TRANSACTION</a>
            <{if $this->acl['transaction']=="M_active"}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:400px;display:none">
                     camp : <{$this->data->tran->camp}><br/>
                    <{foreach from=$this->data->tran->line item="item"}>
                        <{$item}><br/>
                    <{/foreach}>
                     <{foreach from=$this->data->tran->ct item="item"}>
                        <{$item}><br/>
                     <{/foreach}>
                </div>
            <{else}>
                <div class="accTxt" style="position:absolute;left:110px;top:12px;width:320px;display:none">
                    Vous n'avez pas accés à cette rubrique.
                </div>
            <{/if}>
        </div>
</div>



<script>
// creer le silo acc



$(document).ready(function(){
    // navigation
    $("#titreNav").html("Accueil");
    $("#suTitreNav").html("");
    $("#canvas_siloNav").css("display","none");
    $(".navLeftMenu").css("display","none");
    //init var pour silo acc
        //propsection
        ratioPro="<{$this->data->pro->ratio}>";
        colorPro=(ratioPro<=0)?"#D6C9AB":"#83B81A";
        //adm
        ratioAdm="<{$this->data->admin->ratio}>";
        colorAdm=(ratioAdm<=0)?"#D6C9AB":"#83B81A";
        //tran
       
        ratioTran="<{$this->data->tran->ratio}>";
        colorTran=(ratioTran<=0)?"#D6C9AB":"#83B81A";
       
        //exec
        ratioExec="<{$this->data->exec->ratio}>";
        colorExec=(ratioExec<=0)?"#D6C9AB":"#83B81A";
    
    $('body').bind("siloReady",function(){

       $("#maskAcc").remove();
    })
    
    makeSiloAcc();
    attachSiloEvents();
    
    
    $("#preloader").css("display","none");
    $("#accueil").css("display","block");

})

</script>

