<?php

require_once './../library/fpdf/fpdf.php';

class MtelechargementController extends Zend_Controller_Action
{
    // idgrgc
    private $_idBzUser;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    private $_logger;
    
    public function init()
    {
       
        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=  Zend_Registry::get("db");
        
        $this->_helper->layout->disableLayout();
        
        $this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            
       
    }

    public function indexAction()
    {
   
    }
    
    
    public function directdownloadAction(){
        
        $pathRoot=$this->_session->_docRootPathCtunsign;
       
        if($this->getRequest()->getParam("path")){$path=$this->getRequest()->getParam("path");}
        if($this->getRequest()->getParam("ctsign")){$ctsign=$this->getRequest()->getParam("ctsign");}
     
        //$this->_logger->debug("path : ".$this->getRequest()->getParam("path"));
        
        //attention il ne doit pas y avoir d'underscrore dans le nom de fichier
        if(preg_match('/@/', $path) && !$ctsign){
            
            $path=  str_replace("@", "\\", $path);
        }
        
        //Zend_Debug::dump($ctsign,"ctsign");
        
        $path=strtolower($path);
        //Zend_Debug::dump($path,"path");
       
        
        $nom=  explode("\\", $path);
        //Zend_Debug::dump($nom,"nom");
       
        
        $fichier= $pathRoot.$path;
 
        //$this->_logger->debug(print_r($_SESSION,true));
        
         if($ctsign){
           
                /**
                * cas android appel par systeme parceque android ne lit pas pdf ds inappbrowser
            * si bzuser ds l'url on recupere bzuser et path
            */
                if($this->getRequest()->getParam("android")){

                    $pathCt='c:\DocumentsIntranets\CT';
                    //$this->_logger->debug("path : ".$path);

                }else{
                    $pathCt=$this->_session->_docRootPathCtunsign;
                }

                 $fichier=  trim($pathCt,'"')."\\".trim($path,'"');
           }
        
        //Zend_Debug::dump($nom,"nom");
        //Zend_Debug::dump(end($nom),"nom end ");
        //Zend_Debug::dump($fichier,"fichier");
        //return;
        
        /*$this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('./../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            
            $t=array("id"=>$this->_identifiant,"pwd"=>$this->_pwd,"ip"=>$this->_ip,"device"=>$this->_device);
            
            $this->_logger->debug("file exist ? ".file_exists($fichier));
*/
        if(!file_exists($fichier)){
            $this->_logger->debug("le fichier n'existe pas : ".$fichier);
            $this->_helper->layout->setLayout("merrordownload");
             $code='';
            
            $this->view->message=$code;
            //$this->_helper->json(array("message"=>"Votre Document n'est pas"));
        
            return;
        }
         //$this->_logger->debug("le fichier existe  : ".$fichier);
      
        $this->getResponse()->setHeader('content-Type','  application/pdf;');
        $this->getResponse()->setHeader('Content-Disposition', "attachement; filename=".end($nom));
        readfile($fichier);    
        
    }
 /**
  * creer le recepisé pour le contrat
  * Creér le PDF l'enregistre en local  et l'envois
  * @return type
  */   
 public function recepiseAction(){
        
        $this->_helper->layout->disableLayout();
        $this->_helper->viewRenderer->setNoRender(true) ;
        
            $pdfSRC=$this->_session->docpdf['nompdf'];
            $pdfName=$this->_session->docpdf['nompdfA'].".pdf";
            $path=$this->_session->docpdf['path'];
            
            //Zend_Debug::dump($path.$pdfSRC,"docpdf");
            //Zend_Debug::dump($path,"path");
            
            
            $fichier=$path.$pdfSRC;
            
            
            if(!file_exists($fichier)){
       
                //Zend_Debug::dump($this->getRequest()->getParams(),"params");
                $this->_helper->viewRenderer->setNoRender(false) ;
                $this->_helper->layout->setLayout("layout");

                $this->_helper->viewRenderer('error'); 
                $this->view->msg='Le document n\'a pas été trouvé suite à un disfonctionnement. Un courriel de confirmation vous a été envoyé, dans le cas contraire, veuillez  contacter votre commercial.';
                return;
            }
            
            $this->getResponse()->setHeader('content-Length', filesize($fichier));
            $this->getResponse()->setHeader('content-Type','application/pdf');
            $this->getResponse()->setHeader('content-Disposition','attachement;filename="'.$pdfName.'.pdf"');
            
            readfile($fichier);
            
            //destroye session doc
            unset($this->_session->docpdf);
            return;
            
        
    }
  

}

