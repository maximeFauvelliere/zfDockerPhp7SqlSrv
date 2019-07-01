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
    
    
    /**
     *
     * @var la machine client
     */
    private $_device;
    /*
     * ip
     */
    private $_ip;
    
    /*
     * session id PHPSESSID
     */
     private $_sessionId;
    
     /*
      * user agent
      */
     private $_userAgent;
     
     /**
      * temp
      */
     private $flagBrowser=false;
     
     private $_logger;
    /**
     * Constructor: initialize plugin loader
     */
    public function __construct()
    {
       
        
        $this->userAgent = new Zend_Http_UserAgent();
        //recupere les caracterisitques
        //$features
        //["is_mobile"]
        //Zend_Debug::dump($this->userAgent->getDevice()->getFeature("is_desktop"),"feature");
        //Zend_Debug::dump($this->userAgent->getDevice()->getAllFeatures(),"device");
        //$device    = $this->userAgent->getUserAgent();
        //Zend_Debug::dump($this->userAgent->getDevice()->getFeature("is_mobile"),"is mobile");
        
       
         
        
        if($this->userAgent->getDevice()->getFeature("is_desktop")) $this->_device="desktop";
        if($this->userAgent->getDevice()->getFeature("is_mobile")) $this->_device="mobile";
        if($this->userAgent->getDevice()->getFeature("is_tablet")) $this->_device="tablet";
        
        $this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            //$this->_logger->debug("start device type  ".$this->_device);
        //$this->_logger->debug("session  : ".  session_id());
       
       $this->_browsers = strtolower($this->userAgent->getDevice()->getBrowser());
       $this->_browserVersion=  explode(".",$this->userAgent->getDevice()->getBrowserVersion());
       
       $this->_session=Zend_Registry::get("bzSession");
       
       //$this->_broswers=$_SERVER['HTTP_USER_AGENT'];
       
       $this->_ip=$_SERVER['REMOTE_ADDR'];
       $this->_session->_ip=$_SERVER['REMOTE_ADDR'];
       
       if(isset($_COOKIE['PHPSESSID'])){
           $this->_sessionId=$_COOKIE['PHPSESSID']; 
       }
       
         
      //temp 
     /* if($this->_ip=="84.55.165.16" || $this->_ip=="62.160.11.246" || $this->_ip=="88.172.40.112"){
                
         }else{
           $this->_device="toto";
           
     }*/
     
     /**
      * zend and browscap ne detecte pas corectement les tablettes
      * adaptation
      * android renvois mobile ou rien pour les tablet
      * ipad pour iphone
      */
       
       if($this->_device=="mobile"){
           $deviceType=$this->userAgent->getDevice()->getFeature("device");
           $mobileOs= $this->userAgent->getDevice()->getFeature("device_os_token");
           if(preg_match("/ipad/i",$deviceType)){
               $this->_device="desktop";
           }elseif(preg_match("/android/i",$mobileOs) && !$deviceType){
                $this->_device="desktop";
           }
       }
       
      
       //store device 
       $this->_session->deviceType=$this->_device;
       
            
           // $this->_logger->debug("device type after ip :  ".$this->_device);
 
    }
    
    /*
     * Avant la  boucle de distribution aucunes actions n'a était distribuée
     */
    public function dispatchLoopStartup(Zend_controller_Request_Abstract $request)
    {
        
        // controle du browser si deux browser differents pour meme id session
        /**
         * @todo voir le methode qui consite a deconnecter un user avec deux browser different
         * pour un idsession , risque d'etre en presence de vol de session 
         * voir si necessaire???
         */
        /*if(isset($this->_session->_browser)){
            Zend_Debug::dump($this->_session->_browser,"browser session");
            if($this->_session->_browser != $this->_broswers){
                
                $this->destroyUser($request);
            }
            
        }*/
        /**
         *  verification de la session
         * pas de changement de session
         */
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
      
      
      /**
       * controller exclu du test + bzUzer connected
       * test des controllers autorisés sans sessions 
       */
      if($controller!="premiereconnexion" && $controller!="deconnexion" && $controller!="index" && $controller!="login" && $controller!="mindex" && $controller!="mlogin" && $controller!="mpush" && $controller!="mtelechargement" && !$this->_session->idBzUser){
          
          $this->_logger->debug("error no bzuser  ");
          $request->setControllerName('bzerror')
                    ->setActionName('index')
                    ->setParams(array('format'=>'html'));
            Zend_Controller_Request_Abstract::setDispatched(true);
          
      }
      
       //Zend_Debug::dump($this->_device,"device");
       
       /**
        * check les périphéries
        * 
        * 
        */
      
      
       switch ($this->_device) {
            case "desktop":
            //Zend_Debug::dump("desktop");
                
             break;
            
            case "tablet":
                //Zend_Debug::dump("tablette");
                 /*$request->setControllerName('bzerror')
                    ->setActionName('mobile')
                    ->setParams(array('format'=>'html'));
            Zend_Controller_Request_Abstract::setDispatched(true);
                    
            return;*/
                    
                break;
            
            case "mobile":
                //Zend_Debug::dump("mobile");
                //temporaire 
                /*if($this->_ip=="84.55.165.16" || $this_ip=="62.160.11.246"){
                    
                }else{
                    break;
                }*/
                //Zend_Debug::dump($this->_ip,"this ip");
                
           
                
                if($controller=="index" && $action=="index" ){
                
                    $request->setControllerName('Mindex')
                                ->setActionName('index');
            
                }
            
            //Zend_Controller_Request_Abstract::setDispatched(true);
            $layout = Zend_Layout::getMvcInstance();
            $layout->setLayout('mmobiles');
            
            break;
                    
            default:
                break;
        } 
       
      
       
       //liste navigateur version mini
        
       $browserVersionMini=array("firefox"=>19,"internet explorer"=>9,"chrome"=>20,"opera"=>11,"safari"=>5);
       /**
         * condition or mobile et tablette
         * a revoir par la suite en function du dev mobile
         */
       // uniquement les browser dans la liste
       if(!array_key_exists($this->_browsers, $browserVersionMini) && $this->_device=="desktop" && $flagBrowser){
           
           //pour IE11 et > en attendant une mise a jour de zend user agent pour zend 1
            if (strpos($_SERVER['HTTP_USER_AGENT'], 'Trident') !== false) {
             return;
                $request->setControllerName('bzerror')
                    ->setActionName('browsercompatibility')
                    ->setParams(array('format'=>'html','browser'=>'Internet Explorer 11',"version"=>'  <br/> Notre application n\'est pas encore compatible avec  Internet Explorer 11, nous travaillons à sa mise à jour.<br/>En attendant vous pouvez utiliser Google Chrome ou Firefox.<br/>Veuillez nous excuser pour ce désagrément.' ));
            Zend_Controller_Request_Abstract::setDispatched(true);
                return;
                //Zend_debug::dump($_SERVER['HTTP_USER_AGENT'],"user agent");
            }

            $request->setControllerName('bzerror')
                    ->setActionName('browsercompatibility')
                    ->setParams(array('format'=>'html','browser'=>$this->_browsers,"version"=>(int)$this->_browserVersion[0]));
            Zend_Controller_Request_Abstract::setDispatched(true);
            
        }
        
        /**
         * @todo faire pour version navigateur too old
         * 
         */
        
        if((int)$this->_browserVersion[0]< $browserVersionMini[$this->_browsers] && $this->_device=="desktop" && $flagBrowser){
           

            $request->setControllerName('bzerror')
                    ->setActionName('browserversion')
                    ->setParams(array('format'=>'html','browser'=>$this->_browsers,"version"=>$this->_browserVersion[0],"min"=>$browserVersionMini[$this->_browsers]));
            Zend_Controller_Request_Abstract::setDispatched(true);
            
        }
    
    }
    
    public function postDispatch(){
        //Zend_Debug::dump("postdispatch");
    }
    
    /**
     *supprimme les sessions
     * redirige vers page login avec message erreur "vous avez etait deconnecté" 
     * voir timeOver plugin pour deconnexion
     */
    private function destroyUser($request){
            /**
             * @todo detruire la session et rediriger vers index controller.
             * 
             */
    }
 
    
}
