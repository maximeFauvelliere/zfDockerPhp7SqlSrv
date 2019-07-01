<?php
require_once './../library/fpdf/fpdf.php';
class MtransactionController extends Zend_Controller_Action {

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

    public function init() {
        
          //session timeover
          $this->_helper->Timeover($this->getRequest());
         
        $this->_session = Zend_Registry::get("bzSession");
        $this->_idBzUser = $this->_session->idBzUser;
        $this->_ip = $this->_session->_ip;
        $this->_bzUser = $this->_session->bzUser;
        $this->_db = Zend_Registry::get("db");


        /*
          //acl
          $this->_acl=$this->_session->_acl;
          $this->_role=  $this->_session->_role;
         */
        $ajaxContext = $this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index', 'html')
                ->addActionContext('contratsencours', 'json')
                ->addActionContext('contratsencours', 'html')
                ->addActionContext('cttolocksurf', 'html')
                ->addActionContext('cttolocksurf', 'json')
                ->addActionContext('cttolockvalid', 'html')
                ->addActionContext('cttolockvalid', 'json')
                ->addActionContext('transaction', 'json')
                ->addActionContext('transactiondetail', 'json')
                ->addActionContext('offres', 'html')
                ->addActionContext('offres', 'json')
                ->addActionContext('offredetail', 'html')
                ->addActionContext('offredetail', 'json')
                ->addActionContext('sous2struexec', 'html')
                ->addActionContext('sous2struexec', 'json')
                ->addActionContext('sous3peridate', 'html')
                ->addActionContext('sous3peridate', 'json')
                ->addActionContext('sous4pdtderives', 'html')
                ->addActionContext('sous4pdtderives', 'json')
                ->addActionContext('sous5qt', 'html')
                ->addActionContext('sous5qt', 'json')
                ->addActionContext('sous6recap', 'html')
                ->addActionContext('sous6recap', 'json')
                ->addActionContext('sousbzenith', 'html')
                ->addActionContext('sousbzenith', 'json')
                ->addActionContext('sousbzenithrecap', 'html')
                ->addActionContext('sousbzenithrecap', 'json')
                ->addActionContext('sousoptimiz', 'html')
                ->addActionContext('sousoptimiz', 'json')
                ->addActionContext('sous7validation', 'html')
                ->addActionContext('sous7validation', 'json')
                ->setAutoJsonSerialization(false)
                ->initContext();

        $this->_filter = $this->getRequest()->getParam("filter") ? $this->getRequest()->getParam("filter") : null;

        // si pas de filtre en requete on utilise celui de la  session si il existe    
        if (!$this->_filter) {

            if ($this->_session->_filter) {
                $this->_filter = $this->_session->_filter;
            } else {
                /**
                 * @todo faire traitement erreur
                 */
            }
        }

        $this->_camp = $this->_filter["camp"];
        $this->_cultures = $this->_filter["cultures"];
        $this->_structures = $this->_filter["structures"];
        $this->_param = $this->_filter["modify"] ? 0 : 2;

        /* Zend_Debug::dump($this->getRequest()->getParam("filter"),"requete");
          Zend_Debug::dump($this->_filter["camp"],"camp");
          Zend_Debug::dump($this->_filter["cultures"],"cult");
          Zend_Debug::dump($this->_filter["structures"],"strcut");
          Zend_Debug::dump($this->_idBzUser,"idbzuser");
          Zend_Debug::dump( $this->_param,"param");
          Zend_Debug::dump( $this->_ip,"ip");
          Zend_Debug::dump( $_SESSION['bzSession'],"session"); */



        // ACL
        /* if(! $this->_acl->isAllowed($this->_role,'administration','index')){

          $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
          $this->renderScript("/bzerror/index.tpl");
          exit();
          } */
    }

    public function indexAction() {
        
    }

    public function transactionAction() {

        $stmt = $this->_db->prepare("execute ps_ExtWTcontratsM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

        try {
            $stmt->execute();
            $result = $stmt->fetchAll();
        } catch (Zend_Exception $e) {

            //echo $e->getMessage();
        }


        //Zend_debug::dump($result,"ps_ExtWAcours1");
        if (!$result[0][""]) {
            //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
            //$this->_forward("index");
            //return;
        }



        try {

            $array = (array) simplexml_load_string($result[0][""]);
            $this->_helper->json($array);
        } catch (Zend_Exception $e) {
            // plus ou pas  de stock ferme on renvois sur l'index
            //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
        }
    }

    public function transactiondetailAction() {

        $idTi = $this->getRequest()->getParam("idti");
        $idCu = $this->getRequest()->getParam("idcu");

        $stmt = $this->_db->prepare("execute ps_ExtWTcontratsMD @idgrgc='$this->_idBzUser',@idti='$idTi',@clecu='$idCu',@ip='$this->_ip'");

        try {
            $stmt->execute();
            $result = $stmt->fetchAll();
        } catch (Zend_Exception $e) {

            //echo $e->getMessage();
        }


        //Zend_debug::dump($result,"ps_ExtWAcours1");
        if (!$result[0][""]) {
            //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
            //$this->_forward("index");
            //return;
        }



        try {

            $array = (array) simplexml_load_string($result[0][""]);
            $this->_helper->json($array);
        } catch (Zend_Exception $e) {
            // plus ou pas  de stock ferme on renvois sur l'index
            //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
        }
    }

    public function contratsencoursAction() {

        /* if(! $this->_acl->isAllowed($this->_role,'administration','previsionnel')){

          $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
          $this->renderScript("/bzerror/index.tpl");
          exit();
          } */

        if ($this->getRequest()->getParam("format") == "json") {
//@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param
            $stmt = $this->_db->prepare("execute ps_ExtWPOffresUnlockM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {

                //echo $e->getMessage();
            }


            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if (!$result[0][""]) {
                //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                //$this->_forward("index");
                //return;
            }



            try {

                $array = (array) simplexml_load_string($result[0][""]);
                //$array = (array) simplexml_load_string($test);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
        }
    }
    
    public function cttolocksurfAction() {

    }
    
    public function cttolockvalidAction(){
        
         if ($this->getRequest()->getParam("format") == "json") {


                $idct=$this->getRequest()->getParam("idct");
                $idchb=$this->getRequest()->getParam("idchb")?$this->getRequest()->getParam("idchb"):0;
                $qteha=  $this->getRequest()->getParam("qtha");
                $pwd=$this->getRequest()->getParam("pwd");
                $pxEch=$this->getRequest()->getParam("pxech");
                $pxNet=$this->getRequest()->getParam("pxnet");
                
                if(!$pwd){
                    //mot de pass pas renseigné
                    $array = array("success"=>"error","type"=>"pwdempty");
                    $this->_helper->json($array);
                    return;
                }
                
            
                $pwd=md5($pwd);

                $stmt = $this->_db->prepare("execute ps_ExtWPOffresBlock @idgrgc='$this->_idBzUser',@idct=$idct,@idchb=$idchb,@qteha='$qteha',@pwd='$pwd',@ip='$this->_ip',@prixech='$pxEch',@prixnet='$pxNet',@login='$this->_bzUser'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){

                        
                      }

                                      //Zend_Debug::dump($result,"ps_ExtWOPtiVal");
                                      /**
                                       * si erreur different de 0
                                       */
                                      if($result[0]['erreur']){
                                          
                                          switch ($result[0]['erreur']) {
                                                  // pwd error
                                                  case "2":
                                                             if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                                    $array = array("success"=>"error","type"=>"timeout");
                                                                    $this->_helper->json($array);
                                                            }elseif(preg_match('/identifiant/i', $result[0]['msgerreur'])){
                                                                    $array = array("success"=>"error","type"=>"pwd");
                                                                    $this->_helper->json($array);
                                                            }else{
                                                                $array =Array("success"=>"error","type"=>"error");
                                                                $this->_helper->json($array);
                                                            }
                                                      break;

                                                  default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                                      break;
                                              }

                                        }else{
                                            
                                                $xmlSX=new SimpleXMLElement($result[0][""]);
              
                                                $array =Array("success"=>"success","numtran"=>$xmlSX->numtran);
                                                
                                                $this->_helper->json($array);

                                                $pdfCreate=$this->pdfCreate($xmlSX, "", "");

                                                $this->sendConfirm($this->_bzUser,"confirmation contractualisation",null,$pdfCreate,null);

                                        }


         }
    }

    public function offresAction() {

        if ($this->getRequest()->getParam("format") == "json") {

            $stmt = $this->_db->prepare("execute ps_ExtWPOffresM @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {

                //echo $e->getMessage();
            }


            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if (!$result[0][""]) {
                //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                //$this->_forward("index");
                //return;
            }



            try {

                $array = (array) simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
        }
    }

    public function offredetailAction() {

        if ($this->getRequest()->getParam("format") == "json") {

            $pdt = $this->getRequest()->getParam("pdt");
            $idWo = $this->getRequest()->getParam("idwo");
            $idWoHb = $this->getRequest()->getParam("idwohb");

            $stmt = $this->_db->prepare("execute ps_ExtWPOffresMD @idgrgc='$this->_idBzUser',@code='$pdt',@idwo='$idWo',@idwohb='$idWoHb',@camp=$this->_camp,@ip='$this->_ip'");

            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {

                //echo $e->getMessage();
            }


            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if (!$result[0][""]) {
      
            }

            try {

                $array = (array) simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
        }
    }

    /**
     * souscription 2
     * structure execution 
     */
    public function sous2struexecAction() {

        if ($this->getRequest()->getParam("format") == "json") {


            $idWo = $this->getRequest()->getParam("idwo");
            $idWos = 0; //0 pour init 
            $stmt = $this->_db->prepare("execute ps_ExtWFormCtInit @idgrgc='$this->_idBzUser',@idwos=$idWos,@idwo=$idWo,@ip='$this->_ip'");


            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {

                //echo $e->getMessage();
            }


            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if (!$result[0][""]) {
                //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                //$this->_forward("index");
                //return;
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



                $array = (array) simplexml_load_string($xml);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
        }
    }

    /**
     * souscription 3 chois periode et date
     * from data sous2
     */
    public function sous3peridateAction() {
        
        // setter data to db
        if($this->getRequest()->getParam("set")==true){

        $dataSous = $this->getRequest()->getParam("params");

        //param post
        $idWo = $dataSous['idwo'] ? $dataSous['idwo'] : null;
        $idWos = $dataSous['idwos'] ? $dataSous['idwos'] : null;
        $struct = $dataSous['stru'] ? $dataSous['stru'] : null;
        $exec = $dataSous['exec'] ? $dataSous['exec'] : "0";
        $silo = $dataSous['silo'] ? $dataSous['silo'] : null;
        $depart = $dataSous['exec'] ? "depart" : "rendu";
        $periode = $dataSous['periode'] ? $dataSous['periode'] : null;
        $pobs = $dataSous['pobs'] ? $dataSous['pobs'] : 0;
        $paiement = $dataSous['paiement'] ? $dataSous['paiement'] : null;
        //Zend_Debug::dump($depart,"depart");
        //param opti / secu 
        $optidwohb = $dataSous['optimiz'] ? $dataSous['optimiz'] : null;
        $secidwohb = $dataSous['securiz'] ? $dataSous['securiz'] : null;

        $stmt = $this->_db->prepare("execute ps_ExtWFormCtInitVal @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@idwocld='$periode',@idwob='$pobs',@idwopa='$paiement',@idti='$struct',@rd='$depart',@idexe='$exec',@idsil='$silo',@ip='$this->_ip'");

        try {
            $stmt->execute();
            $result = $stmt->fetchAll();
        } catch (Zend_Exception $e) {
            /**
             * traitement des erreures
             */
        }
        
        if($result[0]['erreur']!=0){
                                       
                                       switch ($result[0]['erreur']){
                                           case 2:
                                               if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                   $array = array("success"=>"error","type"=>"timeout");
                                                   $this->_helper->json($array);
                                               }else{
                                                   $array = array("success"=>"error","type"=>"error");
                                                   $this->_helper->json($array);
                                               }
                                                       
                                           break;
                                           default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                           break;
                                                   
                                       }
             }else{
                       $array = array("success"=>"success");
                       $this->_helper->json($array);
             }
        
            
        }
          
    }

    public function sous4pdtderivesAction() {
        
         if ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("set")==true) 
             {
             
             $dataSous=$this->getRequest()->getParam("params");
             
             $idWo=$dataSous['idwo'];
             $idWos=$dataSous['idwos'];
             $optidwohb=$dataSous['optidwohb'];
             $secidwohb=$dataSous['secidwohb'];
             // data to db from pdts derivés
                    $stmt = $this->_db->prepare("execute ps_ExtWFormCtPdtsVal @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@optidwohb='$optidwohb',@secidwohb='$secidwohb',@ip='$this->_ip'");
                               try{
                                    $stmt->execute();
                                    $result=$stmt->fetchAll();
                                   }catch(Zend_Exception $e){
                                      
                                    
                                   }
                              
                                   if($result[0]['erreur']!=0){
                                       
                                       switch ($result[0]['erreur']){
                                           case 2:
                                               if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                   $array = array("success"=>"error","type"=>"timeout");
                                                   $this->_helper->json($array);
                                               }else{
                                                   $array = array("success"=>"error","type"=>"error");
                                                   $this->_helper->json($array);
                                               }
                                                       
                                           break;
                                           default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                           break;
                                                   
                                       }
                                   }else{
                                                   $array = array("success"=>"success");
                                                   $this->_helper->json($array);
                                   }
                                   
                                   
        
        
         }elseif ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("get") ==true ) {

            $pdt = $this->getRequest()->getParam("pdt");
            $idWo = $this->getRequest()->getParam("idwo");
            $idWos = $this->getRequest()->getParam("idwos");
            $stmt = $this->_db->prepare("execute ps_ExtWFormCtPdtsM @idgrgc='$this->_idBzUser',@idwo='$idWo',@idwos='$idWos',@ip='$this->_ip'");

            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {

                //echo $e->getMessage();
            }


            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if (!$result[0][""]) {
                //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                //$this->_forward("index");
                //return;
            }



            try {
                $array = (array) simplexml_load_string($result[0][""]);
                //  $array = (array)simplexml_load_string($xml);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {
          
            }
        }
    }

    public function sous5qtAction() {
        
        
            if ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("set")==true) {
            
                        $idWo = $this->getRequest()->getParam("idwo");
                        $idWos = $this->getRequest()->getParam("idwos");
                        // send data qt to db from sous5qt ajax
                        $qteEng = $this->getRequest()->getParam("qt") ? $this->getRequest()->getParam("qt") : "0";
                        
                        $ha = $this->getRequest()->getParam("haqt")=="hectares" ?true:false;
                        
                        if($ha){
                            $ha=$qteEng;
                            $qteEng="";
                        }


                          $stmt = $this->_db->prepare("execute ps_ExtWFormCtQteValM @idgrgc='$this->_idBzUser',@idwos='$idWos',@qte='$qteEng',@ha='$ha',@ip='$this->_ip'");
                          try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();

                          }catch(Zend_Exception $e){


                          }
                          
                           if($result[0]['erreur']!=0){
                                       
                                       switch ($result[0]['erreur']){
                                           case 2:
                                               if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                   $array = array("success"=>"error","type"=>"timeout");
                                                   $this->_helper->json($array);
                                               }else{
                                                   $array = array("success"=>"error","type"=>"error");
                                                   $this->_helper->json($array);
                                               }
                                                       
                                           break;
                                           default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                           break;
                                                   
                                       }
                                   }else{
                                                   $array = array("success"=>"success");
                                                   $this->_helper->json($array);
                                   }

        }
        
    }

    public function sous6recapAction() {
                
                if ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("get")==true) {
            
                        $idWo = $this->getRequest()->getParam("idwo");
                        $idWos = $this->getRequest()->getParam("idwos");
                $stmt = $this->_db->prepare("execute ps_ExtWFormCtRecapM @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@ip='$this->_ip'");
                        try {
                            $stmt->execute();
                            $result = $stmt->fetchAll();
                        } catch (Zend_Exception $e) {

                        }

                        try {

                            $array = (array) simplexml_load_string($result[0][""]);
                            $this->_helper->json($array);
                        } catch (Zend_Exception $e) {
                            
                        }
                }
    
     
    }

    public function sousbzenithAction() {
            
        if ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("set") ==true) {
           //send data to db
            $dataSous = $this->getRequest()->getParam("params");

            $pdt = $dataSous["pdt"];
            $idWo = $dataSous["idwo"];
            $idWos = $dataSous["idwos"];
            $prix = $dataSous["pxobjectif"];
            $date = $dataSous["dateheure"];
            $stmt = $this->_db->prepare("execute ps_ExtWFormCtPxVal @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@px='$prix',@date='$date',@ip='$this->_ip'");

            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {

                //echo $e->getMessage();
            }


            if($result[0]['erreur']!=0){
                                       
                                       switch ($result[0]['erreur']){
                                           case 2:
                                               if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                   $array = array("success"=>"error","type"=>"timeout");
                                                   $this->_helper->json($array);
                                               }else{
                                                   $array = array("success"=>"error","type"=>"error");
                                                   $this->_helper->json($array);
                                               }
                                                       
                                           break;
                                           default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                           break;
                                                   
                                       }
                                   }else{
                                                   $array = array("success"=>"success");
                                                   $this->_helper->json($array);
                                   }

        }
    }

    public function sousbzenithrecapAction() {


        $idWo = $this->getRequest()->getParam("idwo");
        $idWos = $this->getRequest()->getParam("idwos");

        if ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("get") == true ) {

            $stmt = $this->_db->prepare("execute ps_ExtWFormCtRecapM @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@ip='$this->_ip'");
            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {
                
            }

            //Zend_debug::dump($result,"ps_ExtWAcours1");
            if (!$result[0][""]) {
                //$this->view->message="Une erreur est survenue. Si le problème persite contacter votre commercial.";
                //$this->_forward("index");
                //return;
            }



            try {

                $array = (array) simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {
                // plus ou pas  de stock ferme on renvois sur l'index
                //$this->_forward("index",null, null, array('message'=>"Il n'y a pas de prévisionnel."));
            }
        } 
    }

    public function sousoptimizAction() {

        
        
         if ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("set") ==true) {
             
         }elseif ($this->getRequest()->getParam("format") == "json" && $this->getRequest()->getParam("get") ==true) {
             
             $idWo = $this->getRequest()->getParam("idwo");
             $idWoHb = $this->getRequest()->getParam("idwohb");
             
             $stmt = $this->_db->prepare("execute ps_ExtWOPtiInitM @idgrgc='$this->_idBzUser',@idwohb='$idWoHb',@idwo='$idWo',@ip='$this->_ip'");
            try {
                $stmt->execute();
                $result = $stmt->fetchAll();
            } catch (Zend_Exception $e) {
                
            }

    
            if (!$result[0][""]) {

            }

            try {

                $array = (array) simplexml_load_string($result[0][""]);
                $this->_helper->json($array);
            } catch (Zend_Exception $e) {

            }

 
        }
    }
    
    public function sous7validationAction(){
       
        if($this->getRequest()->getParam("format")=="json" && $this->getRequest()->getParam("set")==true){
            
                                $pwd=md5($this->getRequest()->getParam("pwd"));
                                $idWo=$this->getRequest()->getParam("idwo");
                                $idWos=$this->getRequest()->getParam("idwos");
            
                                // validation produit optimiz
                if($this->getRequest()->getParam("pdt")=="optimiz"){
                    
                                 $dataSous = $this->getRequest()->getParam("params");
                
                                $pdt = $this->getRequest()->getParam("pdt");;
                                $idWo = $dataSous["idwo"];
                                $idWoHb = $dataSous["idwohb"];
                                $idCt = $dataSous["idct"];
                                $qt=$dataSous["qt"]?$dataSous["qt"]:0;
                                $ha=$dataSous["ha"]?$dataSous["ha"]:0;
                                $pwd=md5($this->getRequest()->getParam("pwd"));
                                //$criteres=$idCt.";".$qt.";".$ha;
                                
                                foreach ($dataSous["idct"] as $value) {
                                    //Zend_debug::dump($value,"value");
                                    if($value=="") continue;
                                    
                                    if(preg_match("/t/",$value['qt'])){
                                        $qta=$value['qt'];
                                        $haa="0";
                                    }else{
                                        $haa=$value['qt'];
                                        $qta="0";
                                    }
                                   
                                   $criteres.=$value['ct'].";".(float)$qta.";".(float)$haa.";";
     
                            }
                            
                            //retire le dernier ;
                            $criteres=substr($criteres,0,-1);
                                
                                
            /*$this->_logger = new Zend_Log();
            $redacteur = new Zend_Log_Writer_Stream('../application/logs/errorlog.log');
            $this->_logger->addWriter($redacteur);
            $this->_logger->debug(print_r($this->getRequest()->getParams(),true));
             $this->_logger->debug("criteres : ".$criteres);*/
             
     
                                //ps_ExtWOPtiInitVal @idgrgc INTEGER, @idwo INT, @idwohb INT, @criteresct VARCHAR(500), @ip
                                 $stmt = $this->_db->prepare("execute ps_ExtWOPtiInitVal @idgrgc='$this->_idBzUser',@idwohb=$idWoHb,@idwo=$idWo,@criteresct='$criteres',@ip='$this->_ip'");
                                   try{
                                        $stmt->execute();
                                        $result=$stmt->fetchAll();
                                       }catch(Zend_Exception $e){

                                        
                                      }

                                    if($result[0]['erreur']){
                                        /**
                                         * @todo traitement erreur voir si la liste peux etre vide ??????
                                         */
                                            

                                    }else{

                                           //recupere idwos 
                                           $idWos=$result[0][""];
                                           
                                           
                                           
                                           /*Zend_Debug::dump($this->_bzUser,"bzuser");
                                           Zend_Debug::dump($this->_idBzUser,"$this->_idBzUser");
                                           Zend_Debug::dump($idWos,"idwos");
                                           Zend_Debug::dump($pwd,"pwd");*/
                        
                                            //ps_ExtWOPtiVal @idgrgc INTEGER, @idwos INT,@pwd char(34),@login char(50), @ip
                                            $stmt = $this->_db->prepare("execute ps_ExtWOPtiVal @idgrgc='$this->_idBzUser',@idwos='$idWos',@pwd='$pwd',@login='$this->_bzUser',@ip='$this->_ip'");
                           
                                       try{
                                                $stmt->execute();
                                                $result=$stmt->fetchAll();
                                           }catch(Zend_Exception $e){
                                               
                                          }
                                          
                                         

                                                }
                            
                }else{
                    
                    
                      $stmt = $this->_db->prepare("execute ps_ExtWFormCtVal @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@pwd='$pwd',@login='$this->_bzUser',@ip='$this->_ip'");
                           
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                               }catch(Zend_Exception $e){
                                  
                              }
                
                
                }

                                          /**
                                           * si erreur different de 0
                                           */
             
                                          if($result[0]['erreur']){
                                            
                                              switch ($result[0]['erreur']) {
                                                  // pwd error
                                                  case "2":
                                                             if(preg_match('/timeout/i', $result[0]['msgerreur'])){
                                                                    $array = array("success"=>"error","type"=>"timeout");
                                                                    $this->_helper->json($array);
                                                            }elseif(preg_match('/identifiant/i', $result[0]['msgerreur'])){
                                                                    $array = array("success"=>"error","type"=>"pwd");
                                                                    $this->_helper->json($array);
                                                            }else{
                                                                $array =Array("success"=>"error","type"=>"error");
                                                                $this->_helper->json($array);
                                                            }
                                                      break;

                                                  default:
                                                            $array =Array("success"=>"error","type"=>"error");
                                                            $this->_helper->json($array);
                                                      break;
                                              }

                                               

                                            }else{
                                                
                                                $array =Array("success"=>"success","numtran"=>$result[0]['numtran']);
                                                
                                                

                                                //Zend_Debug::dump($result,"sql ps_ExtWFormCtVal");
                                                /*$this->view->message="</br>Votre contrat a bien été enregistré.</br>Vous allez être automatiquement redirigé.</br>Merci de votre confiance.<br/>";
                                                $this->view->title="Confirmation";
                                                $this->_helper->viewRenderer('validationopti');*/
                                                
                                                $pdfCreate=$this->pdfCreate($xmlSX=new SimpleXMLElement($result[0][""]), "", "");

                                                $this->sendConfirm($this->_bzUser,"confirmation contractualisation",null,$pdfCreate,null);

                                                $this->_helper->json($array);
                                                return;

                                            }
        }
        
    }

    /**
     * envois les données structure execution periode date de l'etape sous3peridate
     */
    private function setDataSous3($request) {

     
    }
    
    /**
     * creer le pdf confirmation le stock en local
     * @param simpleXML $xml
     * @param string $name
     * @param string $path
     */
    private function pdfCreate($xml){
        
        //$xmlSX=new SimpleXMLElement($xml);
        
        $nom=(string)$xml->nom;
        $nomProd=(string)$xml->nomprod;
        $pdfName=(string)$xml->nomaffiche;
        $email=(string)$xml->email;
        $date=(string)$xml->date;
        $path=(string)$xml->path;
        
        $this->_session->docpdf= array("nompdf"=>$nom,"path"=>$path,"nompdfA"=>$pdfName);
        
         // PDF 
        $pdf = new BZPDF();
        
        $pdf->setNumtran((string)$xml->numtran);
        $pdf->setPDFPath($path.$nom);
        $pdf->AliasNbPages();
        $pdf->AddFont('Ubuntu-Regular','');
        $pdf->AddFont('Abel-Regular','');
        $pdf->SetFont('Ubuntu-Regular','',16);
        $pdf->AddPage();
        
       
        // En-tête
        
           //$pdf->Header();
            
        //corps
        
             // Couleurs, épaisseur du trait et police grasse
            $pdf->SetFillColor(96,80,70);
            //$pdf->SetTextColor(255);
            //$pdf->SetDrawColor(128,0,0);
            //$pdf->SetLineWidth(.3);
           // $pdf->SetFont('ubuntu','');

            // Données
            
            $pdf->SetFont('Abel-Regular','',14);
            
            //nom
            $pdf->Cell(190,6,  utf8_decode($nomProd),0,2,'R');
            //email
            $pdf->Cell(190,6,  utf8_decode($email),0,2,'R');
            
            //num Transac
            
            $pdf->Ln(10);
            
            foreach ($xml->recap as $recap) {
                
                     //$pdf->Cell(0,10,$recap,0,1);
                     
                     foreach ($recap as $key => $value) {
                         
                         $pdf->SetFont('Ubuntu-Regular','',14);
 
                         if($pdf->GetY()<257){
                             $pdf->SetFont('Abel-Regular','',12);
                             $pdf->SetTextColor(255, 255, 255);
                             if($value['lib']) $pdf->Cell(190,6,  utf8_decode($value['lib']),'0',2,'L',true);
                             $pdf->SetFont('Ubuntu-Regular','',10);
                             $pdf->SetTextColor(96, 80, 70);
                             $pdf->MultiCell(0,5,utf8_decode($value));
                         }else{
                             $pdf->AddPage();
                             $pdf->SetFont('Abel-Regular','',12);
                             $pdf->SetTextColor(255, 255, 255);
                             if($value['lib']) $pdf->Cell(190,6,  utf8_decode($value['lib']),'0',2,'L',true);
                             $pdf->SetFont('Ubuntu-Regular','',10);
                             $pdf->SetTextColor(96, 80, 70);
                             $pdf->MultiCell(0,5,utf8_decode($value));
                         }  
                         
                         $indent=10;
                         
                         /*
                          *  produit derives
                          */
                         
                        // securiz
                        if($key=="securiz"){
                             $pdf->SetTextColor(255, 255, 255);
                             $pdf->Cell($indent,10);
                             $pdf->SetFont('Abel-Regular','',12);
                             $pdf->Cell(180,6,utf8_decode("Securiz"),0,1,'L',true);
                             $pdf->SetTextColor(96, 80, 70);
                              // Saut de ligne
                                  $pdf->Ln(6);
                                  // check si le bandeau contrat ne vas pas se retrouver juste avant le saut de page
                                 // 6->saut de ligne, 4->hauteur titre contrat,7 premiere ligne contrat
                                 //  on passe a la page suivante si le titre et la premiere ligne ne passe pas sur la precedente.
                                 if($pdf->GetY()+6+4+7>257)  {
                                     $pdf->AddPage();
                                     $pdf->Ln(8);
                                 }

                                 foreach ($value as $b => $securiz) {
                                     //Zend_Debug::dump($value,"value");
                                     if($securiz['lib']=='Id') continue;
                                     if($pdf->GetY()<257){
                                         $pdf->SetFont('Ubuntu-Regular','',10);
                                         if($securiz['lib']) $pdf->Cell($indent,10);$pdf->Cell(60,7,utf8_decode($securiz['lib']).' : ',0,0,'L');
                                         $pdf->SetFont('Ubuntu-Regular','',10);
                                        // $pdf->Cell($indent,10);
                                         $pdf->Cell(0,7,utf8_decode($securiz),0,1);
                                     }else{

                                         $pdf->AddPage();
                                         $pdf->SetFont('Ubuntu-Regular','',10);
                                         if($securiz['lib']) $pdf->Cell($indent,10);$pdf->Cell(60,7,  utf8_decode($securiz['lib']).' : ',0,0,'L');
                                         $pdf->SetFont('Ubuntu-Regular','',10);
                                         //$pdf->Cell($indent,10);
                                         $pdf->Cell(0,7,utf8_decode($securiz),0,1);
                                     }   
                      
                            }
                        
                            //Zend_Debug::dump($pdf->GetY(),"Y");
                     }
                     
                     
                     //optimiz
                        if($key=="optimiz"){
                             $pdf->SetTextColor(255, 255, 255);
                             $pdf->Cell($indent,10);
                             $pdf->SetFont('Abel-Regular','',12);
                             $pdf->Cell(180,6,utf8_decode("Optimiz"),0,1,'L',true);
                             $pdf->SetTextColor(96, 80, 70);
                              // Saut de ligne
                                  $pdf->Ln(6);
                                  // check si le bandeau contrat ne vas pas se retrouver juste avant le saut de page
                                 // 6->saut de ligne, 4->hauteur titre contrat,7 premiere ligne contrat
                                 //  on passe a la page suivante si le titre et la premiere ligne ne passe pas sur la precedente.
                                 if($pdf->GetY()+6+4+7>257)  {
                                     $pdf->AddPage();
                                     $pdf->Ln(8);
                                 }

                                 foreach ($value as $b => $optimiz) {
                                     //Zend_Debug::dump($value,"value");
                                     if($optimiz['lib']=='Id') continue;
                                     if($pdf->GetY()<257){
                                         $pdf->SetFont('Ubuntu-Regular','',10);
                                         if($optimiz['lib']) $pdf->Cell($indent,10);$pdf->Cell(60,7,utf8_decode($optimiz['lib']).' : ',0,0,'L');
                                         $pdf->SetFont('Abel-Regular','',12);
                                        // $pdf->Cell($indent,10);
                                         $pdf->Cell(0,7,utf8_decode($optimiz),0,1);
                                     }else{

                                         $pdf->AddPage();
                                         $pdf->SetFont('Ubuntu-Regular','',10);
                                         if($optimiz['lib']) $pdf->Cell($indent,10);$pdf->Cell(60,7,  utf8_decode($optimiz['lib']).' : ',0,0,'L');
                                          $pdf->SetFont('Ubuntu-Regular','',10);
                                         //$pdf->Cell($indent,10);
                                         $pdf->Cell(0,7,utf8_decode($optimiz),0,1);
                                     }   
                      
                            }
                        
                            //Zend_Debug::dump($pdf->GetY(),"Y");
                     }
   
            }
            
            }
            
            $indent=10;
            
            if($xml->contrat){
               
                 foreach ($xml->contrat as $contrat) {
                      // Saut de ligne
                     $pdf->Ln(6);
                     // check si le bandeau contrat ne vas pas se retrouver juste avant le saut de page
                     // 6->saut de ligne, 4->hauteur titre contrat,7 premiere ligne contrat
                     //  on passe a la page suivante si le titre et la premiere ligne ne passe pas sur la precedente.
                     if($pdf->GetY()+6+4+7>257)  {
                         $pdf->AddPage();
                         $pdf->Ln(8);
                     }
                     
                     $pdf->SetFont('Ubuntu-Regular','',14);
                     $pdf->Cell($indent,10);
                     $pdf->Cell(180,6,utf8_decode("Contrat physique N° ").utf8_decode($contrat->id),0,1,'L',true);
                     $pdf->Ln(4);
                     foreach ($contrat as $key => $value) {
                         //Zend_Debug::dump($value,"value");
                         if($value['lib']=='Id') continue;
                         if($pdf->GetY()<257){
                             $pdf->SetFont('Ubuntu-Regular','',14);
                             if($value['lib']) $pdf->Cell($indent,10);$pdf->Cell(30,7,utf8_decode($value['lib']).' : ',0,0,'L');
                             $pdf->SetFont('Abel-Regular','',12);
                            // $pdf->Cell($indent,10);
                             $pdf->Cell(0,7,utf8_decode($value),0,1);
                         }else{

                             $pdf->AddPage();
                             $pdf->SetFont('Ubuntu-Regular','',14);
                             if($value['lib']) $pdf->Cell($indent,10);$pdf->Cell(30,7,  utf8_decode($value['lib']).' : ',0,0,'L');
                             $pdf->SetFont('Abel-Regular','',12);
                             //$pdf->Cell($indent,10);
                             $pdf->Cell(0,7,utf8_decode($value),0,1);
                         }   
                            //Zend_Debug::dump($pdf->GetY(),"Y");
                     }


                }     
            }
            
            // Saut de ligne
            $pdf->Ln(10);
            $pdf->SetFont('Ubuntu-Regular','',14);
            $pdf->Cell(190,6,  utf8_decode("récépissé édité le ").date("d/m/Y").  utf8_decode(" à ").date( "G:i:s"),0,1,'R');
            $pdf->Cell(190,6,  utf8_decode("Cette transaction sera confirmée par l'envoi d'un contrat."),0,1,'R');
            // Trait de terminaison
           // $pdf->Cell(array_sum($w),0,'','T');
            
           //$this->_piedpage();
           
           try{
               $pdf->Output($path.$nom,"F");
           }catch (Exception $e){
               $this->_helper->LogProduit(array("level"=>"alert","message"=>'Erreur commercialisation<br/> PDF non creé',"numtran"=>$numtran,"email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
           }
           
           if(file_exists($pdf->getPdfPath())){
               return $pdf->getPdfPath();
           }else{
               return false;
           }
    
    }
    
     /**
     * envois un email de confirmation du contrat engagé
     * @param type $to 
     * @param type $subject
     * @param type $message
     * @param type $from
     */
    private function sendConfirm($to,$subject,$message,$pdfFile,$from){
            //$to="bruno.rotrou@gmail.com";
            /**
             * @todo benoit faire ps pour multiple destinataire
             *  appeller base pour plusieurs destinataires
             * boucler sur les destinataire pour les ajouter en copie
             * si resultdestinataires merger les deux tableaux
             */
        
        /*
         * en attente benoit , donné de test 
         */
              //$resultDestinataires=array("bruno.rotrou@free.fr","bruno.rotrou@7cinquante.fr");
            
            // check si pdf bien créer
            if(!$pdfFile){
                mail("administratif@beuzelin.fr","information interne","information interne : une erreur s'est produite sur la création du pdf veuilliez contacter le webmaster et les logs");
                return;
            }
            
            
            $message=$message?utf8_decode($message):utf8_decode("Veuilliez trouver ci joint le récépissé de votre transaction \n Cordialement les établissements Beuzelin");
            
            
            $copie=array("commercial@beuzelin.fr","administratif@beuzelin.fr");
            
            
            
            // mis en commentairre en attente benoit sql
            //if($resultDestinataires) $copie=array_merge($copie, $resultDestinataires);
            $a=  explode("\\",$pdfFile);
            $pdfName=  end($a);
        
            $from=$from?$from:"commercial@beuzelin.fr";
            

            $pdt=$this->getRequest()->getParam("pdt");
            $numct=$this->getRequest()->getParam("numct");
            $header = "From: ".$from." <".$from.">\r\n";
            $header.="Bcc: ".$copie[0].",".$copie[1]."\r\n";
            $header .= "Reply-To: ".$from."\r\n";
            $header .= "MIME-Version: 1.0\r\n";
            
            $uid = md5(uniqid(time()));
            
              // gestion piece joint uniquement si un fichier a était uploadé
            if(file_exists($pdfFile)){
                //create a boundary string. It must be unique 
                $filename=$pdfName;
                $file =$pdfFile;
                $file_size = filesize($file);
                $handle = fopen($file, "r");
                $content = fread($handle, $file_size);
                fclose($handle);
                $content = chunk_split(base64_encode($content));
                $name = basename($file);

                $header .= "Content-Type: multipart/mixed; boundary=\"".$uid."\"\r\n\r\n";
                $header .= "This is a multi-part message in MIME format.\r\n";
                $header .= "--".$uid."\r\n";
                $header .= "Content-type:text/plain; charset=iso-8859-1\r\n";
                $header .= "Content-Transfer-Encoding: 7bit\r\n\r\n";
                $header .= $message."\r\n\r\n";
                $header .= "--".$uid."\r\n";
                $header .= "Content-Type: application/octet-stream; name=\"".$filename."\"\r\n"; // use different content types here
                $header .= "Content-Transfer-Encoding: base64\r\n";
                $header .= "Content-Disposition: attachment; filename=\"".$filename."\"\r\n\r\n";
                $header .= $content."\r\n\r\n";
                $header .= "--".$uid."--";
            
            }
            
            if (mail($to, $subject, $message, $header)) {

               
            }else {
                //log erreur
                //$this->_forward('logproduit','bzerror',null,array("bzParams"=>array("level"=>"alert","message"=>'erreur commercialisation<br/> l\'email n\'as pas été envoyé',"format"=>"html","produit"=>$pdt,"numct"=>$numct,"email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip)));
                $this->_helper->LogProduit(array("level"=>"alert","message"=>'erreur commercialisation<br/> l\'email n\'as pas été envoyé',"format"=>"html","produit"=>$pdt,"numct"=>$numct,"email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
            }
    
 

    }
    
   

}

class BZPDF extends FPDF
{
    /**
     *
     * @var string 
     */
    private $numTran;
    
    private $path;
    
    
    public function setPDFPath($path){
        
        $this->path=$path;
        
    }
    
    public function getPdfPath(){
        
        return $this->path;
    }
    
    public function setNumtran($numTran){
        
        $this->numTran=$numTran;
        
    }
    
    function Header()
    {
         // Logo
            $this->SetFont('Abel-Regular','',20);
            $this->SetTextColor(96, 80, 70);
            $this->SetFillColor(96,80,70);
            $this->Image('./../application/img/logo.png',-12,0,50);
            // Police Arial gras 15
            //$pdf->SetFont('Arial','B',15);
            // Décalage à droite
            //$this->Cell(80);
            
            // Titre
            //$this->Cell(34,10);
            $this->Cell(190,10,utf8_decode('Récapitulatif'),0,0,'R');
            
            // Saut de ligne
            $this->Ln(10);
            
            $this->Cell(190,10,utf8_decode('Transaction N°').utf8_decode($this->numTran),0,0,'R');//.utf8_decode($this->numTran)
            
    
            $this->Ln(30);
    }
    
    function Footer()
    {
       
        // Positionnement à 1,5 cm du bas
        $this->SetY(-30);
        $this->Image('./../application/img/piedpage.jpg',0,null,209,14.99);
        // Police Arial italique 8
        $this->SetFont('Arial','I',8);
        $this->SetTextColor(96, 80, 70);
        //trait
        $this->Cell(190,0,'','T','1','C');
        // Numéro de page centré
        $this->Cell(0,10,'Page '.$this->PageNo(),0,0,'R');
    }
}
