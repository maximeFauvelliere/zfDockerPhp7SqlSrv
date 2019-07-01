<?php

class AccueilController extends Zend_Controller_Action
{
    private $_idBzUser;
    private $_session;
    
    private $_db;
    
    private $_baseURL;
    
    private $_acl;
    private $_role;
    
    private $_data;
    
    private $_filter;
    private $_camp;
    private $_cultures;
    private $_structures;
    
    public function init()
    {
        //session timeover
        $this->_helper->Timeover($this->getRequest());
        

        $this->_session=  Zend_Registry::get("bzSession");
        //Zend_Debug::dump($_SESSION['bzSession'],"session bz");
        $this->_db=  Zend_Registry::get("db");
        
        
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
       
        
        
        $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
      
        //mise en session du filtre 
        if($this->_filter){            
                $this->_session->_filter=$this->_filter;    
            }
        
        
        $this->_camp=$this->_filter["camp"]?$this->_filter["camp"]:null;
        $this->_cultures=$this->_filter["cultures"]?$this->_filter["cultures"]:null;
        $this->_structures=$this->_filter["structures"]?$this->_filter["structures"]:null;
        $this->_param=  $this->_filter["modify"]?0:2;
        
        $this->view->controller="accueil";
        
       
        //Zend_Debug::dump($this->getFrontController()->getBaseUrl());
        // context switch change le context en ajax si ajax detecté dans request
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();

    }

    public function indexAction()
    {
       
        
        //acl menu silo nav
        $this->_role=  $this->_session->_role;
        $this->_acl=$this->_session->_acl;
       
        $siloAcl=array(
            "prospection"=>  $this->_acl->isAllowed($this->_role,"prospection","index")?"M_active":"M_desactive",
            "transaction"=>$this->_acl->isAllowed($this->_role,"transaction","index")?"M_active":"M_desactive",
            "administration"=>$this->_acl->isAllowed($this->_role,"administration","index")?"M_active":"M_desactive",
            "execution"=>$this->_acl->isAllowed($this->_role,"execution","index")?"M_active":"M_desactive",
            "infosmarches"=>$this->_acl->isAllowed($this->_role,"transaction","infosmarches")?"M_active":"M_desactive",
            "contrats"=>$this->_acl->isAllowed($this->_role,"administration","contratsasigner")?"M_active":"M_desactive",
            "analyses"=>$this->_acl->isAllowed($this->_role,"prospection","index")?"M_active":"M_desactive",
            "offres"=>$this->_acl->isAllowed($this->_role,"transaction","offres")?"M_active":"M_desactive"
            );
        
        
        $this->view->acl=$siloAcl;
        
        //---------------------------------------
        $this->view->identifiant=  $this->_session->bzUser;
        $this->view->nom=  $this->_session->nomUser;
        $this->view->prenom=  $this->_session->prenomUser;
        $this->view->baseURL=  $this->_baseURL;
        
        //notifications
        $notifications=$this->_helper->Push();
        if($notifications){
            
            
            foreach($notifications as $key=>$value){
                
                $key=="messages"?$this->view->N_messages=$value:0;
                $key=="taches"?$this->view->N_taches=$value:0;
                $key=="documents"?$this->view->N_documents=$value:0;
                
                
                
            }
            
        
        $stmt = $this->_db->prepare("execute ps_ExtWPAccueilXML @idgrgc='$this->_idBzUser',@camp='$this->_camp',@cultures='$this->_cultures',@structures='$this->_structures',@param='$this->_param',@ip='$this->_ip'");
        
      
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
              
              $xml=$result[0][""];
              
              //Zend_Debug::dump($xml,"result from sql ps_ExtWPAccueil");
              
              if(!$result[0][""]){
                 $this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 return;
             } 
              
       
              $this->view->data=new SimpleXMLElement($xml);
             
                    }
                    
                }
                        
                    }

