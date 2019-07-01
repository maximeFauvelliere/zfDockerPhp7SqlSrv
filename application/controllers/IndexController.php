<?php


class IndexController extends Zend_Controller_Action
{
    
    
    private $_session;
    private $_db;
    
    public function init()
    {   
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('index','json')
                    ->addActionContext('mpo','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        //session 
        $this->_session=Zend_Registry::get("bzSession");
        //db
        $this->_db=  Zend_Registry::get("db");
        
        // l'utilisateur a t'il dejà une session , c'est t'il deja connecté?
        // oui => alors il est redirigé vers sa page accueil personnel
        $aut=  Zend_Auth::getInstance();
        
        if($aut->hasIdentity() && $aut->getIdentity()=="bzUser" ){
            
            $this->_helper->redirector("index","accueil");
        }
        
        
        //gestion des cookies
        if(isset($_COOKIE["bzextranet/identifiant"]) && isset($_COOKIE["bzextranet/pass"]) ){

            $this->view->id=$_COOKIE["bzextranet/identifiant"];
            $this->view->pass=$_COOKIE["bzextranet/pass"];
        }

        //recupere zend db
        $db=Zend_Registry::get('db');
        
        
        
        // utilise le layout login layout sans menu quasi vierge 
       
        
        switch ($this->getRequest()->getParam("format")) {
            case "html":
                    $this->_helper->layout->setLayout('errorajax');
                break;
            case "json":
                    $this->view->data=  json_encode(array("error"=>"Votre session n'est plus active.Veuillez vous connecter à nouveau."));
                    $this->_helper->layout->setLayout('errorjson');
                break;

            default:
                    $this->_helper->layout->setLayout('pconnexion');
                break;
        }
        
  
        
        
    }

    public function indexAction()
    {
        //echo phpinfo();
       
       
       $db=Zend_Registry::get("db");

       $message=$this->_helper->flashMessenger->getMessages();

       if(count($message)>0){

           $this->view->message=$message[0];

       }
       
      
     

    }
    
    public function accesinterneAction(){
         $aut=  Zend_Auth::getInstance();
        
        if($aut->hasIdentity() && $aut->getIdentity()=="bzUser" ){
            
            $this->_helper->redirector("index","accueil");
        }
        
        
    }
    
    public function mpoAction(){
        
         $this->_helper->layout->setLayout('messages');
        
        $login=$this->getRequest()->getParam("login");
        
        $stmt = $this->_db->prepare("execute ps_ExtWMailLite @login='$login'");
                   $this->_helper->LogPs("compte :ps_ExtWMailLite  @login='$login'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }

                        
                        //Zend_Debug::dump($result,"ps_ExtWMailLite");
        
        
        if(!$result[0]['erreur']){
            
            $result=$result[0]["url"];
            $from="commercial@beuzelin.fr";
            $to=$login;
            $subject=utf8_decode("Demande modification de votre mot de passe");
            $message=utf8_decode("Bonjour,<br/> Vous avez demandé la modification de votre mot de passe.\nVeuillez cliquer sur le lien ci-dessous, pour accéder a la page de modification\n").utf8_decode($result).utf8_decode("\nSi vous n'etes pas a l'origine de cette demande veuillez ne pas cliquer sur le lien et contacter un commercial.");
            
            $message='
       <p>
       Bonjour,<br/> Vous avez demandé la modification de votre mot de passe.<br/>
       Veuillez cliquer sur le lien ci-dessous, pour accéder à la page de modification.<br/>
       </p>
       
          <a href="'.utf8_decode($result).'"> '. utf8_decode($result).'</a><br/>
      
        
       <p>
           Si vous n\'êtes pas à l\'origine de cette demande veuillez ne pas cliquer sur le lien et contacter un commercial.<br/>
       </p>
       <p>
        Cordialement
       </p>
       <table>
           <tbody>
               <tr>
                   <td><img src="https://www.e-bzgrains.com/images/metier/logoBz.png" height="93px" width="71px"/></td>
                   <td style="padding-left:15px;">Service commercial SAS Beuzelin</br> <a href="mailto:commercial@beuzelin.fr">commercial@beuzelin.fr</a></br>02 32 67 20 60</td>
               </tr>
           </tbody>
       </table>
      ';
            
            
        }else{
            $this->view->result="Une erreur s'est produite, l'email n'a pas été envoyé.";
        }
        
         $header = "From: ".$from." <".$from.">\r\n";
         $header .= "Reply-To: ".$from."\r\n";
         $header .= "MIME-Version: 1.0\r\n";
         $header .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
            
        if(mail($to,$subject,  utf8_decode($message),$header)){
            $this->view->result="Un email à été correctement envoyé, consultez votre messagerie, puis cliquez sur le lien.";
        }else{
            $this->view->result="Une erreur s'est produite, l'email n'a pas été envoyé.";
        }
        
    }



}

