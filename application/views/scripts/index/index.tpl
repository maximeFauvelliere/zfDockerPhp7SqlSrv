<{if $this->message}>
    <div style="width: 100%;text-align: center;padding-top: 50px;">
        <span><{$this->message}></span>
    </div>
<{/if}>
<div class="alertes" style="display:none"><p></p></div>


<table id="wrapper-con">
    <tbody>
        <tr>
            <td><div id="imgP1"></div></td>
            <td id="td-center-con">
<div style="text-align: center">
    <p>
        Information : Pour activer votre compte Maison e-Bz,<br/> vous devez tout d'abord suivre la procédure de première connexion.<br/><br/> Pour tout complément d'information, contactez-nous au 02.32.67.20.60. 
    </p>
</div>

<div class='login'>
    <form action="/login/login" method="post" class=" loginForm">
        <label>Identifiant</label><br/><input type="text" name="identifiant" id="identifiant"/><br/>
        <label>Mot de passe</label><br/><input type="password" name="pwd" id="pass"/><br/>
        <input id="btConnect" type="submit" value="connexion"/><br/>
        <label>Se souvenir de moi</label><input id="keepme" type="checkbox" name="rememberMe"/><br/>
        <a id="btPwdLost" href="">Mot de passe oublié</a>
    </form>
</div>


</td>
            <td><div id="imgP2"></div></td>
        </tr>
    </tbody>
</table>

<script>

  $("#btPwdLost").click(function(){
    
        if($("#identifiant").val()==""){
            alert("Vous devez entrer votre identifiant avant de demander le renouvellement de votre mot de passe.");
            return false;
        }
        
        //show alerte
        //alert("Un email vient de vous être envoyé. Cliquez sur le lien pour modifier votre mot de passe.");
        //declenche envois email pour changement.
        var data={"login":$("#identifiant").val()};
        $.ajax({
            url:"/index/mpo/format/html",
            data:data,
            type:"POST",
            success:function(data){
                $(".alertes p").text(data);
                $(".alertes").slideDown("slow",function(){
                    $(".alertes").delay(4000).slideUp("slow");
                });
                
                //$.cookie("pwdLost", "true", { expires: 365 * 10, path: '/' });

            }
        })
        
        return false;
    })
        
 
  


function readCookie(name) {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}


$(document).ready(function(){
    
    if(readCookie("bzextranet/keepme")=="1"){
        
        $("#keepme").attr("checked","checked");
        $("#identifiant").val(unescape(readCookie("bzextranet/identifiant")));
        $("#pass").val(unescape(readCookie("bzextranet/pass")));
        
        
    }


})
    
</script>