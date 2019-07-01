<style>
    .shortPass,.badPass span{
        background-color:#FF4040;
    }
    .middlePass span {
        background-color:#f8893f;
        }
    .goodPass span {
        background-color:#04B400;
        }
    .testresult span{
        display:inline-block;
        width:230px;
    }
</style>
<div id="pagecon" data-role="page">
    <div id="logo-ebz">
<img alt="logo" src="/mobiles/css/img/pictos/ebz.min.svg">
</div>
<div id="">
    <div id="">
   <!-- revoir le switche de messages avec retour db parametre-->
        <{if $this->title==true}>
            <p style="font-size:11pt;">Bienvenu(e), vous avez oublié votre mot de passe , ou demandé son changement.<p>
            <p style="font-size:11pt;">Vous devez enregistrer un nouveau mot de passe, pour accéder à votre outil.<p>
        <{else}>
            <p style="font-size:11pt;">Bienvenu(e), pour votre première connexion.</p>
            <p style="font-size:11pt;">Vous devez enregistrer votre mot de passe, pour accéder à votre outil.</p>
        <{/if}>
   
</div>

<{if isset($this->errorMessage[0]) && $this->errorMessage[0]!=""}>
<p class="errorMessage">
<div style="margin-left:102px;border-radius:10px;background-color:#FF9900;padding: 10px;">
    <{$this->errorMessage[0]}>
</div>
    
</p>
<{/if}>

<!--    <div id="txtCdv">
        <p>
        <{$this->cdv}>
        </p>
    </div>-->

<form id="pcform" action="<{$baseUrl}>/premiereconnexion/validation" method="post" name="F_validationCdv">
<!--    <div id="checkBoxCDV">
        <label >j'accepte ces conditions générales d'achats. </label>
        <input type="checkbox"  name="CB_validationCdv"/>
    </div>-->
    <table style="margin: auto;">
        <tbody>
            <tr><td><label>Votre identifiant (email)</label></td></tr>
            <tr><td><input  type="text" id="login"  name="identifiant"></td></tr>
            <tr>
                <td>
                    <label>Votre code tiers</label><br/>
                        <div style="font-size: 8pt;">
                        Code présent sur vos factures, code commençant par "P", contenant 3 lettres suivies de 3 chiffres.
                    </div>
                    
                </td>
                
            </tr>
          
                
            
            <tr><td><input  type="text"  name="codeTiers"  ></td></tr>
            
            <tr>
                <td>
                    <label>Mot de passe</label><br/>
                    <div style="font-size: 8pt;">
                        Votre mot de passe doit comprendre au minimun 9 caractères avec lettres et chiffres.
                        Vous pouvez utiliser les caractères spéciaux.
                    </div>
                </td>
            </tr>
            <tr>
                <td>
                    <div id="wrapperP1" style="min-height: 50px;">
                        <input class="inputPass" id="p1"  type="password" maxlength="16" name="pwd">
                    </div>
                    <div>
                        <input id="showPass" type="checkbox">
                        <label>afficher mot de passe</label>
                    </div>
                </td>
                
            </tr>
            
            <tr><td><label>Confirmation</label></td></tr>
            <tr><td td id="wrapperP2"><input class="inputPass" id="p2" type="password" maxlength="16" name="cPwd" ></td></tr>
        </tbody>
    </table>
    <div style="text-align: center">
    <input type="submit" id="btSubmit" disabled="disabled" value="envoyer"/>
    </div>
    
    
    <div id="passcontent">
    
    </div>
   
    
</form>
    
</div>
</div>
    
    <script>
       
         
        $("input[type='password']").val('');
   
        var passForce=$("#p1").passStrength({userid:"#login"});
            
        disabledSubmit();
        
        $("#showPass").change(function(evt){
        
            content1=$("#p1").val();
            content2=$("#p2").val();
            $("#wrapperP1").empty();
            $("#wrapperP2").empty();
            if($(evt.target).is(':checked')){

                html1='<input class="inputPass" id="p1"  type="text" value="'+content1+'"  maxlength="16" name="pwd"  >'
                html2='<input class="inputPass" id="p2" type="text" value="'+content2+'" maxlength="16" name="cPwd" >'
               
                $("#wrapperP1").append(html1);
                $("#wrapperP2").append(html2);
                
                
               
            }else{
               html1='<input class="inputPass" id="p1"  type="password" value="'+content1+'"  maxlength="16" name="pwd">'
               html2='<input class="inputPass" id="p2" type="password" value="'+content2+'" maxlength="16" name="cPwd" >'
                
                $("#wrapperP1").append(html1);
                $("#wrapperP2").append(html2);
                
            }
            
            passForce=$("#p1").passStrength({userid:"#login"});
            disabledSubmit();
        })
            
        //validation password
        function checkPassStrength(){
            
            if(passForce.score>35){
                $("#btSubmit").removeAttr("disabled");
            }else{
                $("#btSubmit").attr("disabled","disabled");
            }
            
        }
        
        function disabledSubmit(){
            
            $("#p1").keyup(function(){
                                
                 checkPassStrength();
                                    
            }); 

        }			
                                   
				
				
         
        
       
    </script>   