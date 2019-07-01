<{if $this->message}>
    <div style="width: 100%;text-align: center;padding-top: 50px;">
        <span><{$this->message}></span>
    </div>
<{/if}>
<div class="alertes" style="display:none"><p></p></div>
<div style="text-align: center">
    
</div>
<div style="width:100%;text-align: center">
<h1>Acces interne à Bzgrains ne pas diffuser ce lien </h1>
</div>

<div class='login'>
    <form action="/login/logininterne" method="post" class="loginForm" name="bzform">
        <label>Identifiant</label><br/><input type="text" name="identifiant" id="identifiant"/><br/>
        <label>Mot de passe</label><br/><input type="password" name="pwd" id="pass"/><br/>
        <input name="bt" id="btConnect" type="submit" value="connexion"/><br/>
        
    </form>
    
</div>

