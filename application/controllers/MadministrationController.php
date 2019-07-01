<?php

require_once './../library/fpdf/fpdf.php';
require_once './../library/fpdi/fpdi.php';
class MadministrationController extends Zend_Controller_Action
{
    // idgrgc
    private $_idBzUser;
    //acl
    private $_acl;
    private $_role;
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
    
    

    public function init()
    {
        
        //session timeover
        $this->_helper->Timeover($this->getRequest());

        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_ip=$this->_session->_ip;
        $this->_bzUser=$this->_session->bzUser;
        $this->_db=  Zend_Registry::get("db");
        
        
 
        
        /*
        //acl
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        */
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('previsionnel','json')
                    ->addActionContext('accueil','html')
                    ->addActionContext('historique','json')
                    ->addActionContext('historiquedetail','html')
                    ->addActionContext('encours','json')
                    ->addActionContext('ctvalidation','json')
                    ->addActionContext('contratsasigner','html')
                    ->addActionContext('contratsasigner','json')
                    ->addActionContext('ctvalidation','json')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        $this->_filter=$this->getRequest()->getParam("filter")?$this->getRequest()->getParam("filter"):null;
        
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

        $this->_camp=$this->_filter["camp"];
        $this->_cultures=$this->_filter["cultures"];
        $this->_structures=$this->_filter["structures"];
        $this->_param=  $this->_filter["modify"]?0:2;
        
       /* Zend_Debug::dump($this->getRequest()->getParam("filter"),"requete");
        Zend_Debug::dump($this->_filter["camp"],"camp");
         Zend_Debug::dump($this->_filter["cultures"],"cult");
          Zend_Debug::dump($this->_filter["structures"],"strcut");
           Zend_Debug::dump($this->_idBzUser,"idbzuser");
            Zend_Debug::dump( $this->_param,"param");
            Zend_Debug::dump( $this->_ip,"ip");
             Zend_Debug::dump( $_SESSION['bzSession'],"session");*/
           
           
      
        // ACL
        /*if(! $this->_acl->isAllowed($this->_role,'administration','index')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        
        
        
    }
    
    public function indexAction(){
       
    }
    
    public function previsionnelAction(){

        /*if(! $this->_acl->isAllowed($this->_role,'administration','previsionnel')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/


        $stmt = $this->_db->prepare("execute ps_ExtWAPrevisionnelM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
 
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
            
              
           //Zend_debug::dump($result,"ps_ExtWAcours1");
            if(!$result[0][""]){
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 //return;
            } 
            
        

            try{
                
                $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
            
         
        
    }
    
    public function historiqueAction(){
       
       /* if(! $this->_acl->isAllowed($this->_role,'administration','historique')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/

        $stmt = $this->_db->prepare("execute ps_ExtWAHistoriqueM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                //echo $e->getMessage();
              }
        
              if(!$result[0][""]){
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 //return;
            }

            try{
                $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
 
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas d'historique."));
            }
            
         
        
    }
    
    public function historiquedetailAction(){
        
    }
    
    public function encoursAction(){

         /*if(! $this->_acl->isAllowed($this->_role,'administration','encours')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        
        
              
        $stmt = $this->_db->prepare("execute ps_ExtWAcoursM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                 
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 return;
                //echo $e->getMessage();
              }
        
           
            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if(!$result[0][""]){
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
            
            
            try{
                
                 $array = (array)simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
                
            }catch(Zend_Exception $e){
                //  on renvois sur l'index si erreur données
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas d'en cours."));
            }
            
 
    }
    
    public function contratsasignerAction(){
        

        // ACL
        /*if(! $this->_acl->isAllowed($this->_role,'administration','contratsasigner')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        
        if($this->getRequest()->getParam("format")=="json"){
                    //call ps 
                    $stmt = $this->_db->prepare("execute ps_ExtWASign2M @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

                    try {
                            $stmt->execute();
                            $result=$stmt->fetchAll();


                    } catch (Exception $exc) {
                       //Zend_Debug::dump($exc->getTraceAsString());
                    }


                    //si le Xml est null
                   if(!$result[0][""]){
                            
                        }

                    try {
                        // methode qui permet de convertir les attribut du xml en enfants
                $xslDoc = new DOMDocument();
                //Zend_Debug::dump($xslDoc->load("./../library/collection.xsl"),"test");
                $xslDoc->load("./../library/collection.xsl");


                $xmlDoc = new DOMDocument();
                $xmlDoc->loadXML($result[0][""]);

                $proc = new XSLTProcessor();
                $proc->importStylesheet($xslDoc);

                $xml = $proc->transformToXML($xmlDoc);

                        //$xml=simplexml_load_file($xml);
                    //Zend_Debug::dump($xml);    
                         
                     
                          $newXml=simplexml_load_string($xml) ;
                          
                          $this->_session->_docRootPathCtupload=(string)$newXml->pathdep;
                          $this->_session->_docRootPathCtunsign=(string)$newXml->pathct;
                          $this->_session->_docRootPathCtsign=(string)$newXml->pathsign;
                          
                          unset($newXml->pathdep);
                          unset($newXml->pathct);
                          unset($newXml->pathsign);
                          
                       


                          //$array = (array) simplexml_load_string($xml);
                          $array = (array) $newXml;
                         // $array = (array)$xml;
                         $this->_helper->json($array);
                        
                    } catch (Exception $exc) {
                        //echo $exc->getTraceAsString();
                    }

        }
        
    }
    
    public function ctvalidationAction(){
        
        //pas d'erreur avant le traitement

         //$cvValided=$this->getRequest()->getParam("cvValided")?1:0;
         $pwd=$this->getRequest()->getParam("pwd")?md5($this->getRequest()->getParam("pwd")):null;
         $idCt=$this->getRequest()->getParam("idct")?$this->getRequest()->getParam("idct"):null;
         $nomCtUnsign=$this->getRequest()->getParam("path")?$this->getRequest()->getParam("path"):null;
         $nomCtSign=$this->getRequest()->getParam("ctsign")?$this->getRequest()->getParam("ctsign"):null;

         //verifie les champs
        if($pwd==""){
                
                $data['success']="error";
                $data['type']="pwd";
                return $this->_helper->json($data);
        }


            $stmt = $this->_db->prepare("execute ps_ExtWASignature @idgrgc='$this->_idBzUser',@idct='$idCt',@namedoc='$nomCtSign',@pwd='$pwd',@ip='$this->_ip'");
            $stmt->execute();
            
            $data=$stmt->fetchAll();
            
            //modify and record contrat
            //Zend_Debug::dump($data,"retour contrat signé");
            // si pas d'erreur onsigne numériquement le contrat
            if($data[0]['erreur']==1 || $data[0]['erreur']==3){
                
               /* $this->_logger = new Zend_Log();
                $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
                $this->_logger->addWriter($redacteur);
                $this->_logger->debug(json_encode($data));*/
                
                /**
                 * faire traitement erreur
                 */
                $dataError=Array("success"=>"error","type"=>"error","error"=>$data[0]['erreur'],"msg"=>$data[0]["msgerreur"]);
                
                 $this->_helper->json($dataError);
                return;
                
            }elseif( $data[0]['erreur']==2){
                 $dataError=Array("success"=>"error","type"=>"pwd","error"=>$data[0]['erreur'],"msg"=>$data[0]["msgerreur"]);
                 $this->_helper->json($dataError);
                return;
            }
  
            
            $resultMessage=Array("success"=>"success");
            
            
            $this->_helper->layout()->disableLayout();
            $this->_helper->viewRenderer->setNoRender(true);
            echo json_encode($resultMessage);

            //$this->_helper->json($resultMessage);
          
            
            /**
             * @todo verifier si path et ctsign ok
             * log zend plus email
             */
            
            //signer le contrat et le placer dans repertoire
            
                //get all path
                $pathCt=$this->_session->_docRootPathCtunsign;
                $pathCtSign=$this->_session->_docRootPathCtsign;
                // get the contrat
                $ctUnSign=trim($pathCt,'"')."\\".trim($nomCtUnsign,'"');
                $ctSign=trim($pathCtSign,'"')."\\".trim($nomCtSign,'"');
                
                 //Zend_Debug::dump($nomCtSign,"$nomCtSign");
                 //Zend_Debug::dump($idCt,"idct");
               

                $fileName = $ctUnSign;
                //Zend_Debug::dump($ctUnSign,"unsign");
                //Zend_Debug::dump($ctSign,"ctsign");

                
                if(!file_exists($ctUnSign)){
                    
                    $stmt = $this->_db->prepare("execute ps_ExtWASignature @idgrgc='$this->_idBzUser',@idct='$idCt',@pwd='$pwd',@param=1,@ip='$this->_ip'");
                    
                    $stmt->execute();
                    
                    $data[0]['erreur']="3";
                    $data[0]['msgerreur']="Le contrat à signer n'est pas present.";
                    
                     // @todo faire email admin + log
                     
                    return $this->_helper->json(Array("success"=>"error","type"=>"unsign n\'existe pas"));
                }
             
               try{
             
            
                // initiate FPDI 
                $pdf = new FPDI(); 
                // add a page 
                //$pdf->AddPage(); 
                // set the sourcefile 
                $NbPage=$pdf->setSourceFile($fileName); 

               
                for($i=1;$i<=$NbPage;$i++){
                     // import page 1 
                    $tplIdx = $pdf->importPage($i); 
                     // add a page 
                    $pdf->AddPage(); 
                    // use the imported page and place it at point 10,10 with a width of 100 mm 
                    $pdf->useTemplate($tplIdx, 0, 0, 210); 

                    // now write some text above the imported page 
                    $pdf->SetFont('Arial'); 
                    $pdf->SetTextColor(255,0,0); 
                    $pdf->SetXY(40, 260); 

                    $jour = array("Dimanche","Lundi","Mardi","Mercredi","Jeudi","Vendredi","Samedi");

                    $mois = array("","Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre");

                    $dateDuJour = $jour[date("w")]." ".date("d")." ".$mois[date("n")]." ".date("Y")." à ".date("H:i:s");

                    $pdf->Write(6, utf8_decode("Contrat signé numériquement par \n ").trim(utf8_decode($this->_session->prenomUser))." ".trim(utf8_decode($this->_session->nomUser))." le ".utf8_decode($dateDuJour));

                }

                //record
                //$pdf->Output("./../public/bruno1.pdf", 'F'); 
                $pdf->Output($ctSign, 'F'); 
               
                
                }catch(Zend_Exception $e){
                    
                    //retourne erreur et fermeture fenetre
                    $data[0]['erreur']="0";
                    $data[0]['msgerreur']="Contrat signé";
                    
                     // @todo faire email admin + log
                     
                     $this->_helper->json($data);
                    
                    
                    $to="b.degroote@beuzelin.fr";
                    $subject="Erreur création PDF";
                    $message=" une erreur contrat a signer,  création de PDF a été levé, voici les informations du contrat \r\n idgrgc :".$this->_idBzUser."\r\n bz user : ".$this->_bzUser."\r\n idct : ".$idCt."\r\n nom ct pas signé : ".$fileName;
                    $from="serveur@beuzelin.fr";
                    $header = "From: ".$from." <".$from.">\r\n";
                    $header .= "MIME-Version: 1.0\r\n";
                    $header .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
            
                    mail($to,$subject,  utf8_decode($message),$header);
                    
               }
            
           
        
    }

   

}

