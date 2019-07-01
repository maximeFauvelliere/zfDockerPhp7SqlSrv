<?php

class PremiereconnexionController extends Zend_Controller_Action
{

    
    //front controller
    private $fc;
    //connection database
    private $db;
    //id unique producteur id_grgc
    private $_idBzUser;
    //email 
    private $login;
    //code tiers
    private $codeTiers ;
    //pwd a inscrire en db
    private $pwd;
    
    //session
    private $_session;
    
    private $_ip;
    
    
    public function init()
    {
        
        //instance du front controller
        $this->fc = Zend_Controller_Front::getInstance();

        //base url 
        $this->view->baseUrl=$this->fc->getBaseUrl();
       
        //session
         $this->_session=Zend_Registry::get("bzSession");
         
         //ip
         $this->_ip=$this->_session->_ip;
         

       
        //recuperation connection database
        $this->db=Zend_Registry::get("db");
        
         if($this->_session->deviceType=="mobile"){
              $this->_helper->layout()->setLayout("pconnexionmobile");
              $this->_helper->viewRenderer('premiereconnexionmobile');
         }else{
              $this->_helper->layout()->setLayout("pconnexion");
         }
       
        
        
    }

    
    public function premiereconnexionAction(){
        

        // switch title on page pwdLost true pour pass perdu et demande de modification false pour premiere connexion
        $this->view->title=$this->fc->getRequest()->getCookie('pwdLost')=="true"?true:false;
        //efface le cookie
        setcookie ("pwdLost","false",time()+(60*60*24*365*10),"/");
        //error message
        $this->view->errorMessage=$this->_helper->flashMessenger->getMessages('error');
        
        $idBzUser=trim(urldecode($this->fc->getRequest()->getParam('idBzUser')));
        
        //verifie si les variables de premiere connexion bzUser sont présentes
        /*
         * cas ou le lien ds le mail a eté modifié
         * verification des caracteres 
         */
        if(!$idBzUser){
            $this->_helper->flashMessenger->addMessage("code erreur PC_207","error");
                    //redirection page bz avec message erreur
                    $this->_helper->redirector->gotoUrl('/bzerror/index/');
                    return;
        }  else {
            
           //test la chaine bzUser (codeTiers) ne contient que des nombres
            if(preg_match('/([A-Za-z\(\)\{\}\&\~\'\?\*\-_"\#|\/\\ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝàáâãäåçèêëìíîïðòóôõöùúûüýÿ ])/', $idBzUser)){
                
                //message erreur
                $this->_helper->FlashMessenger->addMessage("erreur code:PC_206",'error');
                $this->_helper->redirector->gotoUrl('/bzerror/index/');
                return;
                //$this->_helper->redirector('index', 'index','default',array("errormessage"=>"erreur code:PC_206 : Veuillez contacter votre comercial, une erreur d'identification est survenu"));     
            }
        } 
        if(!isset($this->_session->_idBzUser))
        {     
            
                // controle du idgrgcs
                if($this->fc->getRequest()->getParam('idBzUser')!=null ){
                    
                    $this->_session->_idBzUser=$this->fc->getRequest()->getParam('idBzUser');
                    
                }else
                {
                    
                    $this->_helper->flashMessenger->addMessage("code erreur PC_205","error");
                    //redirection page bz avec message erreur
                    $this->_helper->redirector->gotoUrl('/bzerror/index/');
                    return;
                }
               

        }
        
        
        $this->_idBzUser=  $this->_session->_idBzUser;
        
    }
    
    /**
     * valide le retour de la première connexion
     * @return type
     */
    public function validationAction(){
        
        // si log n'existe pas on le creer'
        if(!file_exists('../application/logs/pconnectlog.log')){
            $fileName = "../application/logs/pconnectlog.log";
            $fileHandle = fopen($fileName, 'w') or die("can't open file");
            fclose($fileHandle);
        }
        
        $param=$this->getRequest()->getParams();
        
        $paramToString="";
        
        foreach ($param as $key => $value) {
            
            if($key=="format") continue;
            if($key=="controller") continue;
            if($key=="action") continue;
            if($key=="module") continue;
            if($key=="pwd") continue;
            if($key=="cPwd") continue;
            $paramToString.="-".$key.":".$value;
            
            
        }
        
         $this->_logger = new Zend_Log();
         $redacteur = new Zend_Log_Writer_Stream('../application/logs/pconnectlog.log');
         $this->_logger->addWriter($redacteur);
            
         $this->_logger->info($paramToString);
         
        

        // si idbzUser
        if(isset($this->_session->_idBzUser)){
            
            //affecte $bzUser
            $this->_idBzUser=$this->_session->_idBzUser;
            /*
             * si id bzuser a etait modifié ds la session
             */
            //test la chaine bzUser (codeTiers) ne contient que des nombres
            if(preg_match('/([A-Za-z\(\)\{\}\&\~\'\?\*\-_"\#|\/\\ÀÁÂÃÄÅÇÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜÝàáâãäåçèêëìíîïðòóôõöùúûüýÿ ])/', $this->_idBzUser)){
                
                //message erreur
                $this->_helper->FlashMessenger->addMessage("erreur code:PC_206 : Veuillez contacter votre comercial, une erreur d'identification est survenu", 'error');
                $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                return;
                //$this->_helper->redirector('index', 'index','default',array("errormessage"=>"erreur code:PC_206 : Veuillez contacter votre comercial, une erreur d'identification est survenu"));     
            }


        }else{
            
            //redirection page bz avec message erreur
            //$this->_helper->redirector('index', 'index','default',array("errormessage"=>"erreur 2 : Veuillez contacter votre comercial, une erreur d'identification est survenue"));
                $this->_helper->FlashMessenger->addMessage("erreur code:PC_205 : Veuillez contacter votre comercial, une erreur d'identification est survenu", 'error');
                $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                return;
        
        }
        
            
        
        // check si les champs son renseigné
        if(empty($_POST['identifiant']) || empty($_POST['pwd'])||empty($_POST['cPwd'])||empty($_POST['codeTiers'])){
            
            //message erreur
            $this->_helper->FlashMessenger->addMessage("Aucun champ de saisie ne doit être vide.", 'error');
            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
            return;
        }
        
        //nettoyage verification des champs email codetiers et pass
        //email
        //nettoyage $post login
          
          $this->identifiant = strip_tags($_POST['identifiant']);
          $this->identifiant = trim($this->identifiant);
        
        //vérification
        if(!filter_var($this->identifiant, FILTER_VALIDATE_EMAIL)){
           
          
            $this->_helper->FlashMessenger->addMessage("votre identifiant n'est pas une adresse email valide.", 'error');
            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
            return;
        }
        

        //check validation pwd
        
       //longeur de la chaine pwd
        $count = strlen($_POST['pwd']);
        
        if(!($_POST['pwd']===$_POST['cPwd'])){

            
            $this->_helper->FlashMessenger->addMessage("Vos mots de passes ne correspondent pas.", 'error');
            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
            return;
            
            
        //}elseif(!preg_match("#[a-z]#", $_POST['pwd']) || !preg_match("#[0-9]#", $_POST['pwd']) 
        }elseif( $count<9 || $count>16){
            

            // mot de pass de mauvaise qualité
           
            //$this->view->errorMessage="mot de passe de mauvaise qualité";
            //$this->render("premiereconnexion");
            $this->_helper->flashMessenger->addMessage('mot de passe de mauvaise qualité.','error');
            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
            return;
        }
        
        
        

        $this->codeTiers=$_POST['codeTiers'];
        $this->login=$this->identifiant;
        $this->pwd=md5(trim($_POST['pwd']));
        
        
        //appel a la base
        $this->db=Zend_Registry::get("db");
        
        
        
        try {
                 $stmt = $this->db->prepare("execute ps_ExtWConnectP @idgrgc=$this->_idBzUser,@codetiers='$this->codeTiers',@login='$this->login',@pwd='$this->pwd',@ip='$this->_ip'");
                 $this->_helper->LogPs("premiereconnexionController :ps_ExtWConnectP @idgrgc,@codetiers,@login,@pwd,@ip");
                 
                 $stmt->execute();
                 
                 $result=$stmt->fetchAll();
                 
                 
                 if(!$result){
                            
                            $this->_helper->FlashMessenger->addMessage("Une erreur est survenue code PC_201.", 'error');
                            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                            return;
                 }
                 
                 switch ($result[0]['erreur']) {
                     case 0:
                             $this->_helper->flashMessenger->addMessage($result[0]['msgerreur'], 'error');
                             $this->_helper->redirector('index','index');
                             return;
                     break;
                     case 2:
                           
                            $this->_helper->FlashMessenger->addMessage($result[0]['msgerreur']." code = PC202", 'error');
                            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                            return;
                            //$this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser.'/message/'.$result[0]['msgerreur']);
                     break;
                     case 1:
                            
                            $this->_helper->FlashMessenger->addMessage("Erreur; Veuillez contacter votre comercial code = PC203", 'error');
                            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                            return;
                     break; 
                     default:
                           
                            $this->_helper->FlashMessenger->addMessage("Erreur; Veuillez contacter votre comercial code = PC_204", 'error');
                            $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                            return;
                     break;
                 }
                 return;

            } catch (Exception $exc) {
                echo $exc->getTraceAsString();
                /**
                 *@todo faire la redirection voir si redirection vers page erreur ?? 
                 */
                //$this->_helper->redirector('index', 'index','default',array("errormessage"=>"erreur 3 : Veuillez contacter votre comercial, une erreur d'identification est survenue"));
                $this->_helper->FlashMessenger->addMessage("Erreur; Veuillez contacter votre comercial code = PC_208", 'error');
                $this->_helper->redirector->gotoUrl('/premiereconnexion/premiereconnexion/idBzUser/'.$this->_idBzUser);
                return;
            }

    }
    
}

