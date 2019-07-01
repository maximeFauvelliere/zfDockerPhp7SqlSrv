<?php
class DocumentsController extends Zend_Controller_Action{
    
     // idgrgc
    private $_idBzUser;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    private $_acl;
    private $_role;
    
    public function init(){
        
        //session timeover
        $this->_helper->Timeover($this->getRequest());
        
        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=  Zend_Registry::get("db");
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        $this->view->controller="documents";
        /**
         * @todo  faire plugin config
         */
        $this->view->pageSize=20;
        

    }
    
   
    
    
    public function indexAction(){
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'documents','index')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="index";
        
         
   
   
            //ps 
                $stmt = $this->_db->prepare("execute ps_ExtWDocGet @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
                
                try {
                        $stmt->execute();
                        $resultXml=$stmt->fetchAll();

                        } catch (Exception $exc) {
                            echo $exc->getTraceAsString();
                        }

                        $xml=$resultXml[0][""];
                        

                        //si le Xml est null
                        /**
                         *@todo voir le cas du xml null voir si afcher bt addlot 
                         */
                        //Zend_Debug::dump($xml,"ps from sql ps_ExtWDocGet");
            
                         
         
                        if(!$xml){
                               // Zend_Debug::dump($resultXml[0][""]);
                                $this->_helper->redirector('index','accueil');
                                exit();
                            }
                            
              $xmlList =new SimpleXMLElement($xml);
              //mise en session du doc root path c:// .....
              $this->_session->_docRootPath=(string)$xmlList['path'];
              
              unset($xmlList['path']);
             
              //Zend_Debug::dump($this->_session->_docRootPath,"path");
              $bzSelectDoc=array();
              foreach ($xmlList->document as $doc) {
                  
                  //Zend_Debug::dump($doc['label'],"doc");
                  // jump les doublons
                  if (array_key_exists((string)$doc['code'], $bzSelectDoc)) continue;
                  
                  $bzSelectDoc[(string)$doc['code']]=$doc['label'];
                  
              }
              
              
            //list de selection filtre
            // plugin config
            $this->view->selectList=$bzSelectDoc;
          
            $this->view->documents=Zend_Json::fromXml($xml,false); 
            
    }
    
    }
?>
