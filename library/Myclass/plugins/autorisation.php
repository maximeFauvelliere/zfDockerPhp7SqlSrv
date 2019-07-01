<?php


/**
 * Description of autorisation
 *
 * @author bruno
 */
class Myclass_plugins_autorisation extends Zend_Controller_Plugin_Abstract{
    
    private $_role;
    
    /**
     * ressource par default est acueil
     * donne acces aux controller index,login,premiereconnexion
     * @var String
     */
    private $_ressource='accueil';
    
    private $_auth;
    
    private $_session;
    
    private $_acl;
    
    private $_fc;
    
    
    public function __construct() {
        
        $this->_fc=  Zend_Controller_Front::getInstance();
        
        $this->_auth=  Zend_Auth::getInstance();
        
        $this->_session= Zend_Registry::get('bzSession');
        
        $this->_acl=$this->_session->_acl;
        //Zend_Debug::dump($this->_acl);
        
            $this->_auth->hasIdentity()?$this->_role=$this->_auth->getIdentity():$this->_role="anonyme";
            $this->_session->_role=  $this->_role;  
            
            //Zend_Debug::dump($this->_role);
    }
    
    
     public function preDispatch(Zend_Controller_Request_Abstract $request) {
         
         
            
         $controllerName=$this->getRequest()->getControllerName();
         
         //attribution de la  ressource
         if($controllerName!='index' && $controllerName!='login'&& $controllerName!='premiereconnexion' && $controllerName!='error' && $controllerName!='bzerror'){
             
             $this->_ressource="compte";
             
         }
         
         //l'utilisateur n'est pas autorisé
         if(!$this->_acl->isAllowed($this->_role,  $this->_ressource))
         {
               // redirige vers le controller index (page d'accueil)
              
               //message erreur
                $flashMessenger=Zend_Controller_Action_HelperBroker::getStaticHelper('FlashMessenger');
                
                $message='vous devez être connecté pour accèder à la page : '.$controllerName.".";
                
                $flashMessenger->addMessage($message);
                
                //Zend_Debug::dump($this->getRequest()->getParam("format"));
                
                if($this->getRequest()->getParam("format")=="html" || $this->getRequest()->getParam("format")=="json"){
                        $redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('redirector');
                        $redirector->gotoUrl("/index/index/format/".$this->getRequest()->getParam("format"));
                }else{
                     $redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('redirector');
                     $redirector->gotoUrl("/index/index/");
                }
               
              
             
         }
         
         
             
    
            
    }
}

?>
