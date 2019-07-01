<?php

require_once './../library/Myclass/Actions/Helpers/LogPs.php';
class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
    
    private $_session;
    
    private $_bzMenu;
    
    private $_db;
    private $_idBzUser;
    private $_ip;
    private $_deviceType;
    
    //initialise 
    protected function _initInit(){
        //démarrage session
        Zend_Session::start();
        
        $this->_session = new Zend_Session_Namespace('bzSession');
        
        
        //mise en cache
        Zend_Registry::set("bzSession", $this->_session );
        
        
        
        /*
         * initialisation en session de l'id session
         * ici car session start dans ce bootstrap
         */
        if(!isset($this->_session->_idSession)){
           
           $this->_session->_idSession=session_id(); 
        }
       
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_deviceType=$this->_session->deviceType;
        
        
        
        // affectation du repertoire pour Myclass
        $autoloader = Zend_Loader_Autoloader::getInstance();
        $autoloader->registerNamespace('Myclass_');
        
       
        
        $front = Zend_Controller_Front::getInstance();
        $front->registerPlugin(new Myclass_Plugins_SecureConnexion());
        
       
         //log
        // si log n'existe pas on le creer'
        if(!file_exists('../application/logs/errorlog.log')){
            $fileName = "../application/logs/errorlog.log";
            $fileHandle = fopen($fileName, 'w') or die("can't open file");
            fclose($fileHandle);
        }
        
    }

    /**
     * affect smarty comme 
     * moteur de template
     * 
     */
    protected function _initView()
    {

        // initialize smarty view
        $view = new Ext_View_Smarty($this->getOption('smarty'));
        // setup viewRenderer with suffix and view
        $viewRenderer = Zend_Controller_Action_HelperBroker::getStaticHelper('ViewRenderer');
        $viewRenderer->setViewSuffix('tpl');
        $viewRenderer->setView($view);

        // ensure we have layout bootstraped
        $this->bootstrap('layout');
        // set the tpl suffix to layout also
        $layout = Zend_Layout::getMvcInstance();
        $layout->setViewSuffix('tpl');
        
        //doc type
        $doctypeHelper = new Zend_View_Helper_Doctype();
        $doctypeHelper->doctype('HTML5');
        
        
        $headLink=new Zend_View_Helper_HeadLink();
        //$headLink->headLink(array('rel' => 'icon','type'=>'image/x-icon','href' => 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAABtUlEQVQ4jY2TvWsUQRjGpxfTiFwgdjZW6SRCvjTZnb3bu9zufeSiObydy3m5KIEUaRTFfJyFRQghFklho60oWIhLQgTBgAgKFkEwlf+Cl+6Kn4VmNruOxBdemHn3eZ99ZuZ5hTBEs+SiPBnLZimDCRuLRsF5l2xMZr2YDo3Ndd9BeZKDr1/4/HFf56cP71lZnCeYsCIS34mrUXl76+RfjuNGeoSKNaj3MTW+vRERJGQmGwI3A8Dzrc0YTgghRJC3f/yLoP02RTtMce/pRQDC1y8TKuR30SimdeFmboz11fuaoDF9jUe75ymMXv5zpNEYwa1iBqE8yeG3A90U5G293t4fZufwLgAPFlooTzJlD9HtdgGYsgcR1+UQTx6vmo8QplCepDQcXSTAnWopuofZ8t+mAVjbu8TSiwu0wxTLr/qo2r/rtdy4xs2Ws4i6J5+ZCB6+OUtTjehaeewKAFX36gmsvf1fz6h8x+iFyAeu22siOOp0OOr81PtjtypPUiiMn4u5ca6S0x9rE1YskwrnKjnzYGUGBnpOGybZ33/m1Kms+dZ8azLLjO8w4zu0JrMEvnXbhP0Fwkbukr7FUZQAAAAASUVORK5CYII='),'PREPEND');
       $headLink->headLink(array('rel' => 'icon','type'=>'image/x-icon','href' => '/images/metier/favicon.ico'),'PREPEND');
       
        return $view;
    }
    
    
    
    
    public function _initDB(){
        
       
        try {
            /*
             * ressource developement  herite de production donc les parametres de bd sont ok en init dev.
             * voir fichier .ini
             */
                $config = new Zend_Config_Ini(APPLICATION_PATH . '/configs/application.ini', 'development');

                //set db instance 
                $db = Zend_Db::factory($config->resources->db);

                //la mettre dans le registe pour persistance
                Zend_Registry::set("db", $db);
                
            }catch (Exception $e) {
                exit( "erreur connection DB : ".$e->getMessage() );
            }
        
        
        
    }
    
     public function _initAcl(){
        
        /**
         *initier les autoristion a ce niveau
         * verifier si autorisation en session ok on continu
         * sinon on appel extwmenu et on fabrique les acl resources
         *  
         */
         
         //Zend_Debug::dump($_SESSION);
         
         $this->_db=Zend_Registry::get("db");
         if($this->_deviceType!="mobile"){
             if(!isset($this->_session->_bzMenu) && $this->_idBzUser){
        
            $stmt = $this->_db->prepare("execute ps_ExtWMenu @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
                    /*$log=new Myclass_Actions_Helpers_LogPs();
                    $log->setPsLog("Bootstrap ACL:ps_ExtWMenu @idgrgc,@ip");*/
            $stmt->execute();

            $result= $stmt->fetchAll();
            
            
             if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
                
            }else{
                
                $menuXml=$result[0][""];
               
            }
            
            
         }else{
            
             $menuXml=$this->_session->_bzMenu;
             //Zend_Debug::dump($menuXml,"xml menu session");
         }
         
            /**
             * on gere le menu seulment apres le login idbzuser existe
             */
            
            if($this->_idBzUser){
            
             try {

                if (!$this->_session->_bzMenu) {
                    $this->_session->_bzMenu = $menuXml;
                  
                }

                $this->_bzMenu = new SimpleXMLElement($menuXml);
               
            } catch (Exception $e) {
                
                $this->_bzMenu=NULL;
                
                
            }
            
         
            
            /**
             * @todo si menuxml mal retourné l'appli plante 
             * voir a traiter plus tard avec les acl
             */
            $acl=new Zend_Acl();
            
            //roles
            $acl->addRole(new Zend_Acl_Role('anonyme'));
            $acl->addRole(new Zend_Acl_Role('bzUser'),'anonyme');
            
            $allowedControllers=array("compte","accueil","error","bzerror");
            $denyControllers=array();
            $allowActions=array();
            $denyActions=array();
            
            /**
             * ressource autorisées pour controllers primaires
             * attention le retour par simpleXml
             * doit etre transtypé en string ou autre  sinon php retourne un objet 
             */
            foreach ($this->_bzMenu->rubriques as $v) {
                if((int)$v['checked']){
                    //Zend_Debug::dump(strtolower((string)$v['code']),"code");
                    $allowedControllers[]=strtolower((string)$v['code']);
                }
               
            }
            /**
             *resource interdites controllers primaires
             */
            foreach ($this->_bzMenu->rubriques as $v) {
                if(!(int)$v['checked']){
                    //Zend_Debug::dump(strtolower((string)$v['code']),"code");
                    $denyControllers[]=  strtolower((string)$v['code']);
                }
               
            }
            /**
             * ressource autorisées pour controllers secondaires
             */
            foreach ($this->_bzMenu->rubriques as $value) {
                if((int)$value['checked']){
                    foreach ($value->menu as $v) {

                        if((int)$v['checked']){

                            $allowedControllers[]=  strtolower((string)$v['code']);
                            
                        }
                    }
                }
            }
            
            /**
             *ressources interdites pour controllers secondaire 
             */
            foreach ($this->_bzMenu->rubriques as $value) {
                if((int)$value['checked']){
                    foreach ($value->menu as $v) {

                        if(!(int)$v['checked']){
//Zend_debug::dump(strtolower((string)$v['code']),"action interdites");
                            $denyControllers[]=  strtolower((string)$v['code']);
                            
                        }
                    }
                }
            }
            
            
            
            /**
             *clean doublons  $allowedControllers
             */
           
            $allowedControllers=  array_unique($allowedControllers);
            $denyControllers=  array_unique($denyControllers);
            
             
            
            /**
             *add ressources 
             **/
            foreach(array_unique(array_merge($allowedControllers, $denyControllers)) as $value){
                $acl->addResource(new Zend_Acl_Resource($value));  
            }
            
            /**
             *action privilèges non autorisées pour subrubriques
             */
            foreach ($this->_bzMenu->rubriques as $value) {
                if ((int) $value['checked']) {
                    foreach ($value->subrubrique as $v) {
                        if (!(int) $v['checked']) {
                                   //Zend_Debug::dump((string)$value['code'],"controller");
                                   // Zend_Debug::dump((string)$v['code'],"action");
                            $acl->deny('bzUser',  strtolower((string) $value['code']),  strtolower((string) $v['code']));
                        }
                    }
                }
            }
            
            
            
            /**
             *action privilèges non autorisées pour menu
             */
            foreach ($this->_bzMenu->rubriques as $value) {
                if((int)$value['checked']){
                    foreach ($value->menu as $v){
                        
                        if(!(int)$v['checked']){
                                   // Zend_Debug::dump((string)$value['code'],"controller");
                                   // Zend_Debug::dump((string)$v['code'],"action");
                                    $acl->deny('bzUser',  strtolower((string)$value['code']),  strtolower((string)$v['code']));
                        }
                             
                         
                    }
                }
            }
            

            //Zend_Debug::dump($acl->getResources());

            $acl->allow('anonyme', 'accueil');
            $acl->allow('anonyme','error');
           
            //tout acces 
            //$acl->allow('bzUser');
            $acl->allow('bzUser',$allowedControllers);
            
            //Zend_Debug::dump($allowedControllers,"allowedControllers");
 
            $this->_session->_acl=$acl;
       //Zend_debug::dump($acl,"acl");
       //Zend_Debug::dump($menuXml,"xml menu session");
            //initialise le plugin d'authenfication
            $fc = Zend_Controller_Front::getInstance();
            $fc->registerPlugin(new Myclass_plugins_autorisation());

        }
         }else{
             /**
              * voir les acl pour mobile 
              */
        
         }
        
        
        
      
         
        
        
        
        
    }
    
    
    public function _initPlugin(){
        
        Zend_Controller_Action_HelperBroker::addPrefix("Myclass_Actions_Helpers");
        Zend_Controller_Action_HelperBroker::addHelper(new Myclass_Actions_Helpers_Getglobal());
        if($this->_session->deviceType!="mobile"){ Zend_Controller_Action_HelperBroker::addHelper(new Myclass_Actions_Helpers_Push());}
        Zend_Controller_Action_HelperBroker::addHelper(new Myclass_Actions_Helpers_LogPs());
        Zend_Controller_Action_HelperBroker::addHelper(new Myclass_Actions_Helpers_Timeover());
        Zend_Controller_Action_HelperBroker::addHelper(new Myclass_Actions_Helpers_LogProduit());
        Zend_Controller_Action_HelperBroker::addHelper(new Myclass_Actions_Helpers_Logmatifconnexions());
        
    }
    
}

