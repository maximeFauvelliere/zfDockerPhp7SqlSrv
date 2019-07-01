<?php
/**
 * gestion des analyses en attente
 */
class AnalysesattentesController extends Zend_Controller_Action
{
     // idgrgc
    private $_idBzUser;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    
    private $_data;
    
    private $_filter;
    private $_camp;
    private $_cultures;
    private $_structures;
    private $_acl;
    private $_role;
    
    public function init()
    {
        //session timeover
        $this->_helper->Timeover($this->getRequest());
        
        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=  Zend_Registry::get("db");
        
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        
        $ajaxContext= $this->_helper->getHelper('AjaxContext');
        
        $ajaxContext->addActionContext('analyses','html')
                    ->addActionContext('setanalyse','html')
                    ->addActionContext('affecteanalyse','json')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','analyses')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
       
       
       
        $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
        
        //mise en session du filtre 
        if($this->_filter){            
                $this->_session->_filter=$this->_filter;    
            }
         // si pas de filtre en requete on utilise celui de la  session si il existe    
         if(!$this->_filter){
           
             if($this->_session->_filter){
                 $this->_filter=$this->_session->_filter;
             }else{
                 /**
                  * @todo faire traitement erreur
                  */
             }
             
        }
        
        //Zend_Debug::dump($this->_filter,"filter");
        
        $this->_camp=$this->_filter["camp"];
        $this->_cultures=$this->_filter["cultures"];
        $this->_structures=$this->_filter["structures"];
        $this->_param=  $this->_filter["modify"]?0:2;
        
        /**
         * @todo voir plugin
         */
        $this->view->pageSize=5;
        $this->view->controller="analysesattentes";
    }
    
    public function analysesAction(){
        
        $stmt = $this->_db->prepare("execute ps_ExtWAnalysesAtt @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
              //Zend_Debug::dump($result,"analyse attentes");

             if(!$result[0][""]){
            /**
             * @todo gestion erreur
             */
            
            }else{
                
                /**
                 * @todo gestion erreur retour sql
                 */
                
                $this->_data=$result[0][""];

                
            }
        
            
            $this->view->data=Zend_Json::fromXml($this->_data,false); 
        
    }
    
    /**
     * affectation des analyses
     */
    public function setanalyseAction(){
        
         $idgra=$this->getRequest()->getParam("idana");
         $stmt = $this->_db->prepare("execute ps_ExtWFormAnaAtt @idgrgc='$this->_idBzUser',@idgra=$idgra,@ip='$this->_ip'");
        
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
              

             if(!$result[0][""]){
            /**
             * @todo gestion erreur
             */
            
            }else{
                
                /**
                 * @todo gestion erreur retour sql
                 */
                
                //$this->_data=$result[0][""];
                $this->view->state=Zend_Json::fromXml($result[0][""],false);
                
            }
            //Zend_Debug::dump($result,"setanalyse");
    }
    
    public function affecteanalyseAction(){
        
        
        $idgra=$this->getRequest()->getParam("idgra");
        $idlot=$this->getRequest()->getParam("idlot");
        $checked=$this->getRequest()->getParam("checked");
        $stmt = $this->_db->prepare("execute ps_ExtWAnalyseLotMod @idgrgc='$this->_idBzUser',@idwtrl=$idlot,@idgra='$idgra',@checked=$checked,@ip='$this->_ip'");
        
        
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
              //Zend_Debug::dump($result);
              
                 
        $this->view->result=  json_encode($result[0]);
       
        
    }
    
              }
        
