<?php

require_once './../library/fpdf/fpdf.php';

class TelechargementController extends Zend_Controller_Action
{
    // idgrgc
    private $_idBzUser;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    
    public function init()
    {
        //session timeover
        $this->_helper->Timeover($this->getRequest());

        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=  Zend_Registry::get("db");
        
        $this->_helper->layout->disableLayout();
        
       
    }

    public function indexAction()
    {

        $params=$this->getRequest()->getParams();
        
        if($this->getRequest()->getParam("id")){$id=$this->getRequest()->getParam("id");}
        if($this->getRequest()->getParam("tdoc")){$tdoc=$this->getRequest()->getParam("tdoc");}
        if($this->getRequest()->getParam("from")){$from=$this->getRequest()->getParam("from");}

        $stmt = $this->_db->prepare("execute ps_ExtWDownload @idgrgc='$this->_idBzUser',@id='$id',@type='$tdoc',@ip='$this->_ip'");
       try{
            $stmt->execute();
            $result=$stmt->fetchAll();
           }catch(Zend_Exception $e){

          }
       //Zend_Debug::dump($_SERVER['HTTP_USER_AGENT'],"user agent");
       //Zend_Debug::dump(strpos($_SERVER['HTTP_USER_AGENT'],'MSIE'),"user agent");

        if(!$result || !file_exists($result[0]['path'])){
            
            $this->_helper->layout->setLayout("errordownload");
            $code='';
            
            $this->view->message=$code;
                    
            return;
        }

   
        $fichier = $result[0]["path"];
        
        /**
         * @todo faire attention il ne faut aucun code dans le fichier TPL sinon erreur pdf corrompu ou vide
         */
        
       if (isset($_SERVER['HTTP_USER_AGENT']) && (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) {
           //IE
            //header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
            //header('Pragma: public');
           //header("Content-Type: application/force-download");
           //header("Content-Type: application/octet-stream");
           //header("Content-Type: application/download");

            $this->getResponse()->setHeader('Expires', '0');
            $this->getResponse()->setHeader('Cache-Control', 'must-revalidate');
            $this->getResponse()->setHeader('Cache-Control', 'post-check=0');
            $this->getResponse()->setHeader('Cache-Control', 'pre-check=0');
            $this->getResponse()->setHeader('Pragma', 'public');
          
} else {
    // not IE
   
  //header('Pragma: no-cache');
}

        $this->getResponse()->setHeader('content-Length', filesize($fichier));
        $this->getResponse()->setHeader('content-Type','  application/force-download; filename='.$result[0]["nom"]);
        $this->getResponse()->setHeader('content-Type','  application/download; filename='.$result[0]["nom"]);
        $this->getResponse()->setHeader('Content-Disposition', "attachement; filename=".$result[0]["nom"]);

        readfile($fichier);       
    }
    
    
    public function directdownloadAction(){

        $pathRoot=$this->_session->_docRootPath;
        if($this->getRequest()->getParam("path")){$path=$this->getRequest()->getParam("path");}
        if($this->getRequest()->getParam("ctsign")){$ctsign=$this->getRequest()->getParam("ctsign");}

        //attention il ne doit pas y avoir d'underscrore dans le nom de fichier
        if(preg_match('/@/', $path) && !$ctsign){
            
            $path=  str_replace("@", "\\", $path);
        }
        
        
        
        $path=strtolower($path);
        
       
        
        $nom=  explode("\\", $path);
        
       
        
        $fichier= $pathRoot.$path;
        
         if($ctsign){
           
             $pathCt=$this->_session->_docRootPathCtunsign;
              $fichier=  $pathCt."//".$path;
        }
        
        //Zend_Debug::dump($nom,"nom");
        //Zend_Debug::dump(end($nom),"nom end ");
        //Zend_Debug::dump($path,"fichier");

        if(!file_exists($fichier)){

            $this->_helper->layout->setLayout("errordownload");
             $code='';
            
            $this->view->message=$code;
            return;
        }
        
        
       if (isset($_SERVER['HTTP_USER_AGENT']) && (strpos($_SERVER['HTTP_USER_AGENT'], 'MSIE') !== false)) {
           //IE
            //header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
            //header('Pragma: public');
           //header("Content-Type: application/force-download");
           //header("Content-Type: application/octet-stream");
           //header("Content-Type: application/download");

            $this->getResponse()->setHeader('Expires', '0');
            $this->getResponse()->setHeader('Cache-Control', 'must-revalidate');
            $this->getResponse()->setHeader('Cache-Control', 'post-check=0');
            $this->getResponse()->setHeader('Cache-Control', 'pre-check=0');
            $this->getResponse()->setHeader('Pragma', 'public');
          
} else {
    // not IE
   
  //header('Pragma: no-cache');
}

        $this->getResponse()->setHeader('content-Length', filesize($fichier));
        $this->getResponse()->setHeader('content-Type','  application/force-download; filename='.end($nom));
        $this->getResponse()->setHeader('content-Type','  application/download; filename='.end($nom));
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

