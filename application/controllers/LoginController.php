<?php

require_once '../library/Myclass/bz.php';

class LoginController extends Zend_Controller_Action
{
     
    //connection database
    private $db;
    private $identifiant;
    private $pwd;
    private $_session;
    
    public function init()
    {
        //session timeover
        $this->_helper->Timeover($this->getRequest());
        //db
        $this->db=Zend_Registry::get("db");
        // desactive l'aide de vue
        $this->_helper->viewRenderer->setNoRender(true) ;
        
        $this->_session=  Zend_Registry::get('bzSession');
        
        
        
        
    }
    
    public function logininterneAction(){
       

        //nettoyage $post login
         
          $this->identifiant =  strip_tags($_POST['identifiant']);

        
        //pwd 
       
          $this->pwd=trim($_POST['pwd']);

        

        //authentification
        $auth = Zend_Auth::getInstance();

        $result= $auth->authenticate(new bz($this->identifiant,$this->pwd,$this->db,$this->_session->_ip));
        
        // message erreur provenant de la base
        $message=$result->getMessages();
        
        if($result->isValid()){

            $this->_helper->flashMessenger->addMessage($message['message']);
            $this->_helper->redirector("index","accueil");
        }else{

           $this->_helper->flashMessenger->addMessage($message['message']);
           // retourne a l'index
           $this->_helper->redirector("index","index");
        }
        
       
        
        
    }

    public function loginAction()
    {

        // check si les variables sont là
        if(empty($_POST['identifiant']) || empty($_POST['pwd'])){
            
            $message="Vous devez remplir tous les champs pour continuer";
            
            $this->_helper->flashMessenger->addMessage($message);
            
            $this->_helper->redirector('index', 'index','default');
  
            
        }

        //nettoyage $post login
         
          $this->identifiant =  strip_tags($_POST['identifiant']);
          

        //verification du format email
        if(!filter_var($this->identifiant, FILTER_VALIDATE_EMAIL)){

            $this->_helper->flashMessenger->addMessage("votre identifiant n'est pas une adresse email valide");
            $this->_helper->redirector('index', 'index');

        }
        
        
        //pwd 
       
          $this->pwd=trim($_POST['pwd']);

        //remember me
       if(isset($_POST['rememberMe'])){
            
            //add cookies
            setcookie("bzextranet/identifiant", $this->identifiant, time()+60*60*24*1000, "/"); 
            setcookie("bzextranet/pass", trim($this->pwd), time()+60*60*24*1000, "/");
            setcookie("bzextranet/keepme","1", time()+60*60*24*1000, "/");
            
        } else {
            //vide les cookies
            setcookie("bzextranet/identifiant","", NULL, "/"); 
            setcookie("bzextranet/pass","" , NULL, "/"); 
            setcookie("bzextranet/keepme","0", NULL, "/");
        }
        

        //authentification
        $auth = Zend_Auth::getInstance();

        $result= $auth->authenticate(new bz($this->identifiant,md5($this->pwd),$this->db,$this->_session->_ip));
        
        // message erreur provenant de la base
        $message=$result->getMessages();
        
        if($result->isValid()){

            $this->_helper->flashMessenger->addMessage($message['message']);
            $this->_helper->redirector("index","accueil");
        }else{

           $this->_helper->flashMessenger->addMessage($message['message']);
           // retourne a l'index
           $this->_helper->redirector("index","index");
        }
        
       
 
    }


}

