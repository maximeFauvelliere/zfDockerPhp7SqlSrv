<?php

require_once './../library/fpdf/fpdf.php';
require_once './../library/fpdi/fpdi.php';
class AdministrationController extends Zend_Controller_Action
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
        
        
        //acl
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('previsionnel','html')
                    ->addActionContext('accueil','html')
                    ->addActionContext('historique','html')
                    ->addActionContext('encours','html')
                    ->addActionContext('ctvalidation','json')
                    ->addActionContext('contratsasigner','html')
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
        
        
        /**
         * @todo  faire plugin config
         */
        $this->view->pageSize=5;
        
        $this->view->controller="administration";
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'administration','index')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
    }
    
    public function indexAction(){
        
        $this->view->action="index";

        // action precedente = forward  on envois un message
        if($this->getRequest()->getParam('message')){
            $this->view->message=$this->getRequest()->getParam('message');
        }
       
        
        
        $stmt = $this->_db->prepare("execute ps_ExtWAcc @idgrgc='$this->_idBzUser',@code='ADM',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
        $this->_helper->LogPs("Administration : ps_ExtWAcc @idgrgc,@code,@camp,@cultures,@structures,@param,@ip");
           
           try{
           $stmt->execute();
           $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
           
                echo $e->getMessage();
              }
              
              
            /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                $this->_data='<cellules>
                                <cellule titre="Historique" img=""></cellule>
                                <cellule titre="En cours" img=""></cellule>
                                <cellule titre="Prévisionnel" img=""></cellule>
                             </cellules>';
            }else{
                if(count($result)){
                    $this->_data=$result[0][""];
                }else{
                    $this->_data=null;
                }
                
            }

            //Zend_Debug::dump($this->_data,"data brutes");
            
            try{
               $this->view->data=Zend_Json::fromXml($this->_data,false);
            }  catch (ErrorException $e){
                
            }
           
           //call contrats a signer
           $callCt = $this->_db->prepare("execute ps_ExtWASign1 @idgrgc='$this->_idBzUser'");
           
           $this->_helper->LogPs("Administration : ps_ExtWASign1 @idgrgc");
         
           
           $callCt->execute();
           
           $result=$callCt->fetchAll();

           $this->view->ct=$result[0]["nb"];
           
           $this->renderScript("/administration/accueil.ajax.tpl");
    }
    
    public function previsionnelAction(){
        
        if(! $this->_acl->isAllowed($this->_role,'administration','previsionnel')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="previsionnel";

        $stmt = $this->_db->prepare("execute ps_ExtWAPrevisionnel @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
        $this->_helper->LogPs("Administration : ps_ExtWAPrevisionnel @idgrgc,@camp,@cultures,@structures,@param,@ip");  
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
            
              
           //Zend_debug::dump($result,"ps_ExtWAcours1");
            if(!$result[0][""]){
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 //return;
            } 
            
        
           if(count($result)){
                $this->_data=$result[0][""];
           }else{
                $this->_data=null;
           }

            try{
                
                //$this->view->data=Zend_Json::fromXml($this->_data,false);
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
            
            
           
    }
    
    public function historiqueAction(){
        
        if(! $this->_acl->isAllowed($this->_role,'administration','historique')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="historique";

        $stmt = $this->_db->prepare("execute ps_ExtWAHistorique @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
       
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
              if(!$result[0][""]){
                 //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 //$this->_forward("index");
                 //return;
            }
            if(count($result)){
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
            
            try{
                
                //$this->view->data=Zend_Json::fromXml($this->_data,false);
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index",null, null, array('message'=>"Il n'y a pas d'historique."));
            }
            
            
           
    }
    
    public function encoursAction(){
        
         if(! $this->_acl->isAllowed($this->_role,'administration','encours')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="encours";
              
        $stmt = $this->_db->prepare("execute ps_ExtWAcours1 @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
       
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                 
                 $this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;
                //echo $e->getMessage();
              }
        
           
            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if(!$result[0][""]){
                 /*$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                 $this->_forward("index");
                 return;*/
            }
            
            if(count($result)){
                
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
                
            //Zend_Debug::dump($result[0][""]);
            
            try{
                
                //$this->view->data=Zend_Json::fromXml($this->_data,false);
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                //  on renvois sur l'index si erreur données
                $this->_forward("index",null, null, array('message'=>"Il n'y a pas d'en cours."));
            }
            
            
    }
    
    public function contratsasignerAction(){
        
        $this->view->action="contratsasigner";
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'administration','contratsasigner')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
  
        //call ps 
        $stmt = $this->_db->prepare("execute ps_ExtWASign2 @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
        
        try {
                $stmt->execute();
                $resultXml=$stmt->fetchAll();
                
                
        } catch (Exception $exc) {
            echo $exc->getTraceAsString();
        }
        
        //Zend_Debug::dump($resultXml,"ps_ExtWASign2");
        
        //si le Xml est null
       if(!$resultXml[0][""]){
            //Zend_Debug::dump($resultXml[0][""]);
            $this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
            $this->_forward('index',null,null,array("format"=>"html"));
            return;
            }
        
        try {
              $xml=$resultXml[0][""];
              $xmlList =new SimpleXMLElement($xml);
              $this->_session->_docRootPathCtupload=(string)$xmlList['pathdep'];
              $this->_session->_docRootPathCtunsign=(string)$xmlList['pathct'];
              $this->_session->_docRootPathCtsign=(string)$xmlList['pathsign'];
              
              unset($xmlList['pathdep']);
              unset($xmlList['pathct']);
              unset($xmlList['pathsign']);
      
              $this->_data=Zend_Json::fromXml($xmlList->asXML(),false);
        } catch (Exception $exc) {
            echo $exc->getTraceAsString();
        }
            
        
        
        
        
       

        $this->view->data=$this->_data;
        
    }
    
    public function ctvalidationAction(){
        
        //pas d'erreur avant le traitement

         //$cvValided=$this->getRequest()->getParam("cvValided")?1:0;
         $pwd=$this->getRequest()->getParam("pwd")?md5($this->getRequest()->getParam("pwd")):null;
         $idCt=$this->getRequest()->getParam("idCt")?$this->getRequest()->getParam("idCt"):null;
         $nomCtUnsign=$this->getRequest()->getParam("path")?$this->getRequest()->getParam("path"):null;
         $nomCtSign=$this->getRequest()->getParam("ctSign")?$this->getRequest()->getParam("ctSign"):null;
         
         //verifie les champs
        if(!$pwd){
                
                $data[0]['erreur']="2";
                $data[0]['msgerreur']="Mot de passe non renseigné";
                return $this->view->result=json_encode($data);
        }
        
         //return $this->view->result=json_encode("success");
            $stmt = $this->_db->prepare("execute ps_ExtWASignature @idgrgc='$this->_idBzUser',@idct='$idCt',@namedoc='$nomCtSign',@pwd='$pwd',@ip='$this->_ip'");
            $this->_helper->LogPs("Administration :ps_ExtWASignature @idgrgc,@idct,@pwd,@ip");
            $stmt->execute();
            
            $data=$stmt->fetchAll();
            
            //modify and record contrat
            //Zend_Debug::dump($data,"retour contrat signé");
            // si pas d'erreur onsigne numériquement le contrat
            if($data[0]['erreur']==1 || $data[0]['erreur']==2 ||$data[0]['erreur']==3){
                
                 $this->view->result=json_encode($data);
                return;
                
            }
                
            
            
             $this->view->result=json_encode($data);
           
            
            /**
             * @todo verifier si path et ctsign ok
             * log zend plus email
             */
            
            //signer le contrat et le placer dans repertoire
            
                //get all path
                $pathCt=$this->_session->_docRootPathCtunsign;
                $pathCtSign=$this->_session->_docRootPathCtsign;
                // get the contrat
                $ctUnSign=$pathCt."\\".$nomCtUnsign;
                $ctSign=$pathCtSign."\\".$nomCtSign;
                
                //Zend_Debug::dump($ctUnSign,"ct sign");
                
               

                $fileName = $ctUnSign;
                
                if(!file_exists($ctUnSign)){
                    
                    $stmt = $this->_db->prepare("execute ps_ExtWASignature @idgrgc='$this->_idBzUser',@idct='$idCt',@pwd='$pwd',@param=1,@ip='$this->_ip'");
                    
                    $stmt->execute();
                    
                    $data[0]['erreur']="3";
                    $data[0]['msgerreur']="Le contrat à signer n'est pas present.";
                    
                     // @todo faire email admin + log
                     
                    return $this->view->result=json_encode($data);
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

                    $pdf->Write(6, utf8_decode("Contrat signé numériquement par \n ").trim($this->_session->prenomUser)." ".trim($this->_session->nomUser)." le ".utf8_decode($dateDuJour));

                }

                //record
                //$pdf->Output("./../public/bruno1.pdf", 'F'); 
                $pdf->Output($ctSign, 'F'); 
            
            
                }catch(Zend_Exception $e){
           
                    //retourne erreur et fermeture fenetre
                    $data[0]['erreur']="0";
                    $data[0]['msgerreur']="Contrat signé";
        
                     // @todo faire email admin + log
                     
                     $this->view->result=json_encode($data);
                    
                    
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

    /**
     * Upload les contrat signés 
     * manuellement par le producteur 
     * @return type
     */
     public function fileuploadAction(){
        
        $this->_helper->layout->setLayout("uploadiframe");
        //extention autorisées
        $extensions = array('.pdf', '.png', '.jpg', '.jpeg','.docx','.doc','.xls','.xlsx','.odt','.ods','.txt','.csv');
        // récupère la partie de la chaine à partir du dernier . pour connaître l'extension.
        $extension = strrchr($_FILES['bzUpload']['name'], '.');
        //Ensuite on teste
        if(!in_array($extension, $extensions)) //Si l'extension n'est pas dans le tableau
        {
             echo 'Le format que vous souhaitez envoyer n\'est pas autorisé <br/>
                    fichiers autorisés : word, pdf,txt,open office,images (sauf tif et BMP)' ;
             $this->view->result="error";
             return;
        }
        $idCt=$this->getRequest()->getParam('idct');
        $dossier = $this->_session->_docRootPathCtupload;
        $uiName=$this->_idBzUser."_".time().".".pathinfo($_FILES['bzUpload']['name'], PATHINFO_EXTENSION);
        
        //$this->view->result=(string)$dossier."\\". basename($_FILES['bzUpload']['name']);
         
         
        //Zend_Debug::dump($dossier,"dossier");
  
        if(move_uploaded_file($_FILES['bzUpload']['tmp_name'], $dossier."\\".$uiName)) 
        {
               
               $stmt = $this->_db->prepare("execute ps_ExtWDocUpload @idgrgc='$this->_idBzUser',@idct='$idCt',@doc='$uiName',@ip='$this->_ip'");
               $this->_helper->LogPs("Administration :ps_ExtWDocUpload @idgrgc='$this->_idBzUser',@idct='$idCt',@doc='$uiName',@ip='$this->_ip'");
               $stmt->execute();
            
               $result=$stmt->fetchAll();
               
               /**
                * @SEE coté sql pas possible de savoir si le fichier est vraiment déposé sur le serveur
                * donc on ne prend pas en consideration le retour de la base qui tjrs faux
                */
               //Zend_debug::dump($result,"ps_ExtWAcours1");
                /*if(!$result[0][""]){
                     $this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                     $this->_forward("index");
                     return;
                }*/
               
               if($result[0]['erreur']==0){
                   
                   $this->view->result="success";
               }else{
                   
                   $this->view->result="error";
               }
              /**
               * @todo gestion retour sql pour info producteur
               */
              //Zend_Debug::dump($data);
              
             
        }else{
              echo 'Echec de l\'envois de votre piece jointe';
              $this->view->result="error";
              return;
        }

    }


}

