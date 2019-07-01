<?php

/**
 * Description of tpssessionslimite_mesaidesactions
 *
 * @author bruno
 */
class Myclass_Plugins_SecureConnexion extends Zend_Controller_Plugin_Abstract {
    
    
    /*
     * session
     */
    private $_session;
    
    /*
     * broswers
     */
    private $_broswers;
    
    /*
     * ip
     */
    
    private $_ip;
    
    /*
     * session id PHPSESSID
     */
     private $_sessionId;
    
 
    /**
     * Constructor: initialize plugin loader
     */
    public function __construct()
    {
       
        
       /**
        * placer ici user agent pour browser 
        */
       $this->_session=Zend_Registry::get("bzSession");
       
       $this->_broswers=$_SERVER['HTTP_USER_AGENT'];
       
       //Zend_Debug::dump($this->_broswers,"browser");
       
       $this->_ip=$_SERVER['REMOTE_ADDR'];
       
       if(isset($_COOKIE['PHPSESSID'])){
           $this->_sessionId=$_COOKIE['PHPSESSID']; 
       }
      
       
 
    }
    
    /*
     * Avant la  boucle de distribution aucunes actions n'a était distribuée
     */
    public function dispatchLoopStartup(Zend_controller_Request_Abstract $request)
    {
        //Zend_Debug::dump("dispatchLoopStartup");
        
        // controle du browser
        if(isset($this->_session->_browser)){
            
            if($this->_session->_browser != $this->_broswers){
                
                $this->destroyUser($request);
            }
            
        }
        // verification de la session
        if(isset($this->_session->_idSession)){
            
            if($this->_session->_idSession != $this->_sessionId){
                
                $this->destroyUser($request);
            }
            
        }

        
        //verification ip a chaque requete
        if(isset($this->_session->_ip)){
            
            if($this->_session->_ip!=$_SERVER['REMOTE_ADDR'])
            {
                $this->destroyUser($request);
            }
        }
        
        
        
    }
    
    /*
     * fin de boucle
     * après que toute les action est étaient distribuer 
     */
    public function dispatchLoopShutdown()
    {
        
       
        
        //initialisation browser
       if(!isset($this->_session->_browser)){
           
           $this->_session->_broswser=$this->_broswers;
        }
        
        // controle de l'ip 
        if(!isset($this->_session->_ip))
        {
            $this->_session->_ip=$this->_ip;
        }
        
    }
    
    
    public function preDispatch($request){
      
      
      $controller=$request->getControllerName();
      $action=$request->getActionName();

      if($controller!="premiereconnexion" && $controller!="deconnexion" && $controller!="index" && $controller!="login" && !$this->_session->idBzUser){
          
          
          $request->setControllerName('bzerror')
                    ->setActionName('index')
                    ->setParams(array('format'=>'html'));
            Zend_Controller_Request_Abstract::setDispatched(true);
          
          
      }
     return;
        $userAgent = new Zend_Http_UserAgent();
        Zend_Debug::dump($userAgent->getUserAgent(),"user agent");
       $browser = strtolower($userAgent->getDevice()->getBrowser());
       $browserVersion=  explode(".",$userAgent->getDevice()->getBrowserVersion());
       
       //liste navigateur version mini
       $browserVersionMini=array("firefox"=>19,"internet explorer"=>8,"chrome"=>20,"opera"=>11,"safari"=>5);
       
       // uniquement les browser dans la liste
       if(!array_key_exists($browser, $browserVersionMini)){

            $request->setControllerName('bzerror')
                    ->setActionName('browsercompatibility')
                    ->setParams(array('format'=>'html','browser'=>$browser,"version"=>$browserVersion[0]));
            Zend_Controller_Request_Abstract::setDispatched(true);
            
        }
        
        /**
         * @todo faire pour version navigateur too old
         * 
         */
        
        if($browserVersion[0]< $browserVersionMini[$browser]){
           

            $request->setControllerName('bzerror')
                    ->setActionName('browserversion')
                    ->setParams(array('format'=>'html','browser'=>$browser,"version"=>$browserVersion[0],"min"=>$browserVersionMini[$browser]));
            Zend_Controller_Request_Abstract::setDispatched(true);
            
        }
    
    }
    
    public function postDispatch(){
        //Zend_Debug::dump("postdispatch");
    }
    
    /**
     *supprimme les sessions
     * redirige vers page login avec message erreur "vous avez etait deconnecté" 
     */
    
    private function destroyUser($request){
        
       // Zend_Session::destroy();
       /**
        *@todo suuprimmer bzuser et no toue le ssesion 
        */
       /*$r = new Zend_Controller_Action_Helper_Redirector;
       $r->setUseAbsoluteUri();
       $r->gotoSimpleAndExit('index');*/
       
        
    }
 
    
}
