<?php

require_once '../library/Myclass/bz.php';

class MloginController extends Zend_Controller_Action{
     
    //connection database
    private $db;
    private $identifiant;
    private $pwd;
    private $_session;
    
    
    public function init(){
        
        //db
        $this->db=Zend_Registry::get("db");
        // desactive l'aide de vue
        //$this->_helper->viewRenderer->setNoRender(true) ;
        
        $this->_session=  Zend_Registry::get('bzSession');
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('login','json')
                            ->setAutoJsonSerialization(false)
                            ->initContext();
        //Zend_Debug::dump($this->getRequest()->getParam("format"),"request");
    }
   
    /**
     * a modifier pour acces interne a partir mobile
     * l'idée :
     * un identifiant commun ex : accesinterne@beuzelin.fr
     * un pwd commun ex : toto
     * -> nous redirige vers une page speciale pour connection avec identifiant client
     */
    public function logininterneAction(){
       
        return;
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

    public function loginAction(){
        //Zend_Debug::dump($_POST['pwd'],"request"); //->isXmlHttpRequest()
        //$this->_helper->json(array("result"=>"error","message"=>"test"));
        //$this->_helper->layout()->disableLayout();
        //$this->_helper->json(array("result"=>"error","message"=>"test"));
//$this->_helper->viewRenderer->setNoRender(true);
//echo json_encode(array("result"=>"error","message"=>"test"));
        //return;
//Zend_Debug::dump($_SESSION,"ip");
        // check si les variables sont là
        if(empty($_POST['identifiant']) || empty($_POST['pwd'])){
            
            $message="Vous devez remplir tous les champs pour continuer";
            $this->_helper->json(array("result"=>"error","message"=>$message));
            
            
 
        }else{

            //nettoyage $post login

              $this->identifiant =  strip_tags($_POST['identifiant']);
              $this->identifiant =  trim($this->identifiant);

             //flag
             $valideEmail=true;
            //verification du format email
            if(!filter_var($this->identifiant, FILTER_VALIDATE_EMAIL)){

                $message="votre identifiant n'est pas une adresse email valide";
                $this->_helper->json(array("result"=>"error","message"=>$message));

            }
            
            if(!$valideEmail) return;


            //pwd 

              $this->pwd=trim($_POST['pwd']);

            //authentification
            $auth = Zend_Auth::getInstance();
            
            if(!preg_match('/^[a-f0-9]{32}$/', $this->pwd)){
                
                $this->pwd=md5($this->pwd);
                
            }
                
             

            $result= $auth->authenticate(new bz($this->identifiant,$this->pwd,$this->db,$this->_session->_ip,"mobiles"));
            
            if($result->isValid()){

               $message="";
                $this->_helper->json(
                        array("result"=>"success",
                                "message"=>$message,
                                "acc"=>  json_decode($this->_session->mAcc),
                                "menu"=> json_decode($this->_session->mMenu),
                                "filter"=> json_decode($this->_session->mFilter),
                                "idbzuser"=>$this->_session->idBzUser,
                                "idSession"=>$this->_session->_idSession
                            ));
                //$this->_helper->redirector("index","Maccueil");
            }else{
                
                //$message="Identification incorrecte.";
                 // message erreur provenant de la base
                $message=$result->getMessages();
                $this->_helper->json(array("result"=>"error","message"=>$message["message"]));
               //$this->_helper->flashMessenger->addMessage($message['message']);
               // retourne a l'index
               //$this->_helper->redirector("index","Mindex");
            }
        
    }
        
       
 
    }
    
    /**
     * login appli rapide retourn uniquement les infos de loggin
     * pas la page acc
     * @return type
     */
    public function logindirectAction(){
 
        // check si les variables sont là
        if(empty($_POST['identifiant']) || empty($_POST['pwd'])){
            
            $message="Vous devez remplir tous les champs pour continuer";
            $this->_helper->json(array("result"=>"error","message"=>$message));
 
        }else{

            //nettoyage $post login

              $this->identifiant =  strip_tags($_POST['identifiant']);
              $this->identifiant =  trim($this->identifiant);

             //flag
             $valideEmail=true;
            //verification du format email
            if(!filter_var($this->identifiant, FILTER_VALIDATE_EMAIL)){

                $message="votre identifiant n'est pas une adresse email valide";
                $this->_helper->json(array("result"=>"error","message"=>$message));

            }
            
            if(!$valideEmail) return;


            //pwd 

              $this->pwd=trim($_POST['pwd']);

            //authentification
            $auth = Zend_Auth::getInstance();
            
            //check auth avec MD5 direct 
            if(!preg_match('/^[a-f0-9]{32}$/', $this->pwd)){
                
                $this->pwd=md5($this->pwd);
                
            }
                
             

            $result= $auth->authenticate(new bz($this->identifiant,$this->pwd,$this->db,$this->_session->_ip,"mobiles",true));
            
            if($result->isValid()){

               $message="";
                $this->_helper->json(
                        array("result"=>"success",
                                "message"=>$message
                            ));
                //$this->_helper->redirector("index","Maccueil");
            }else{
                
                $message="Identification incorrecte.";
                $this->_helper->json(array("result"=>"error","message"=>$message));
               
            }
        
    }
        
       
 
    }


}

