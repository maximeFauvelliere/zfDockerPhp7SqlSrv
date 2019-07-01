<?php
require_once './../library/fpdf/fpdf.php';
class TransactionController extends Zend_Controller_Action
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
    
    private $_gData;

    // durée max pour commercialisation
    private $time=900;//900;
    
    public function init()
    {

        //session timeover
        $this->_helper->Timeover($this->getRequest());
        
        $this->_session=  Zend_Registry::get("bzSession");
        $this->_idBzUser=$this->_session->idBzUser;
        $this->_bzUser=$this->_session->bzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=  Zend_Registry::get("db");
        
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;

        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('offres','html')
                    ->addActionContext('info','html')
                    ->addActionContext('getcontrattolock','html')
                    ->addActionContext('getcontrats','html')
                    ->addActionContext('setcontrat','html')
                    ->addActionContext('etape1','html')
                    ->addActionContext('etape2','html')
                    ->addActionContext('etape2bzenith','html')
                    ->addActionContext('etape3','html')
                    ->addActionContext('etape4','html')
                    ->addActionContext('etape5','html')
                    ->addActionContext('validationct','html')
                    ->addActionContext('errorsouscription','html')
                    ->addActionContext('addlot','html')
                    ->addActionContext('getdetailcontrat','html')
                    ->addActionContext('validatecontrat','html')
                    ->addActionContext('setblocprix','html')
                    ->addActionContext('validateblock','html')
                    ->addActionContext('getoptimises','html')
                    ->addActionContext('setopti','html')
                    ->addActionContext('getoffreopti','html')
                    ->addActionContext('getoffreopti','json')
                    ->addActionContext('infosmarches','html')
                    ->addActionContext('optimizcontratstolock','html')
                    ->addActionContext('analysecom','html')
                    ->addActionContext('analysecomcultures','html')
                    ->addActionContext('analysecomstructures','html')
                    ->addActionContext('analysecomcontrats','html')
                    ->addActionContext('analysecomtableau','html')
                    ->addActionContext('analysecomsynthese','html')
                    ->addActionContext('updatelotqte','html')
                    ->addActionContext('matif','html')
                    ->addActionContext('matif','json')
                    ->addActionContext('ctaffectation','html')
                    ->addActionContext('ctaffectationlist','html')
                    ->addActionContext('ctaffectvalid','html')
                    ->addActionContext('ctaffectvalid','json')
                    ->addActionContext('lotsaffect','json')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'transaction','index')){
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
                 //Zend_Debug::dump("pas de filtre en session");
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
        
         $this->view->pageSize=5;
         $this->view->controller="transaction";
         
         
    }

    
    public function indexAction()
    {
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'transaction','index')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
          //action
          $this->view->action="index";
          
          $stmt = $this->_db->prepare("execute ps_ExtWAcc @idgrgc='$this->_idBzUser',@code='TRA',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
        
           
            //Zend_Debug::dump($result,"result acc TRA from sql");
           // Zend_Debug::dump(is_null($result[0][""]),"result is null");
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur'] || is_null($result[0][""]) ){
                /**
                 * @todo traitement erreur les offres ne peuvent pas être vides
                 */
                
                $this->_data='<cellules>
                                <cellule titre="Erreur données" img=""></cellule>
                                <cellule titre="Erreur données" img=""></cellule>
                             </cellules>';
            }else{
                /**
                *@todo faire tres attention car se base sur nom du xml comme une chaine vide 
                * il serait bien de regler se problème, pour etre sur que cela ne pose pas
                * de soucis pour le suite. 
                */
                $this->_data=$result[0][""];
            }

            try{
               $this->view->data=Zend_Json::fromXml($this->_data,false); 
            }  catch (ErrorException $e){
               
               
                //Zend_Debug::dump($e);
            }
            
            // Zend_Debug::dump($this->_data);
            
            //call contrats a affecter
           $callCt = $this->_db->prepare("execute ps_ExtWTCtNAffect @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

           $callCt->execute();
           
           $result=$callCt->fetchAll();
           
           //Zend_Debug::dump($result[0]["nb"],"ps_ExtWTCtNAffect");
           $this->view->ct=$result[0]["nb"];
           
          
    }
    
    
    public function offresAction(){
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'transaction','offres')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        $this->view->action="offres";
        
        $stmt = $this->_db->prepare("execute ps_ExtWProduits @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
           
            //Zend_Debug::dump($result,"result produits from sql");
            
            // check si les attribut img,color et info sont non null
            //envois un email a l'admin pour info
            if($result){
                $resultXML=new SimpleXMLElement($result[0][""]);
            }else{
           
                return;
            }
            /**
             * @todo voir comment prevenir, lors de l'ajout d'1 nouvelle offre
             * si une erreur existe dans cette offre.
             */

            //Zend_Debug::dump($resultXML,"result XML produits from sql");
            
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                /**
                 * @todo traitement erreur les offres ne peuvent pas être vides
                 */
                
                $this->_data='<cellules>
                                <cellule titre="error data " img=""></cellule>
                                <cellule titre="error data" img=""></cellule>
                             </cellules>';
            }else{
               
                $this->_data=$result[0][""];
            }
            
            //Zend_Debug::dump($this->_data,"data brutes");
            //Zend_Debug::dump($this->_data);
            try{

               $this->view->data=Zend_Json::fromXml($this->_data,false); 
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
            
        
    }
    
    public function getcontratsAction(){
        
         if(! $this->_acl->isAllowed($this->_role,'transaction','getcontrats')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="getcontrats";
        $this->view->message=$this->getRequest()->getParam("message");
        
        $contrat=$this->getRequest()->getParam("contrat");

        $contrat= preg_replace("/ /", "", $contrat);
        //Zend_Debug::dump($contrat,"contrat");
        $stmt = $this->_db->prepare("execute ps_ExtWPOffres @idgrgc='$this->_idBzUser',@code='$contrat',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
           
            //Zend_Debug::dump($result,"result from sql ps_ExtWPOffres");
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
                $this->_data='<cellules>
                                <cellule titre="error data " img=""></cellule>
                                <cellule titre="error data" img=""></cellule>
                             </cellules>';
            }else{
                
                $this->_data=$result[0][""];
            }
            
            //Zend_Debug::dump($this->_data,"retour sql");

            $xml=new SimpleXMLElement($this->_data);
            //Zend_Debug::dump($xml);
            $this->view->data= $xml;
            //return;
            try{
               $this->view->dataJson=Zend_Json::fromXml($this->_data,false); 
                
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }

    }
    
    /**
     * formulaire de souscription en plusieurs etapes
     */
    public function setcontratAction(){
        
        // ACL
        //Zend_Debug::dump($this->_acl->isAllowed($this->_role,'transaction','setcontrat'),"setContrat");
        if(!$this->_acl->isAllowed($this->_role,'transaction','setcontrat')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        // check timeOut pour la souscription formulaire
        if($this->_session->_ctTimeOut){
            $now=  mktime();
            if($now-$this->_session->_ctTimeOut>$this->time){
                // play cancel
                          unset($this->_session->_ctTimeOut);
                          $idwos=$this->getRequest()->getParam("idsous");
                          $stmt=$this->_db->prepare("execute ps_ExtWFormCtDel @idgrgc='$this->_idBzUser',@idwos=$idwos,@ip='$this->_ip'");
                          $stmt->execute();
                          // tpsover = a default dans switch js
                          $this->view->error="tpsover";
                          $this->view->message="Vous avez dépassé le temps limite(15mn) pour votre souscription, veuillez recommencer";
                          $this->view->title="Erreur temps limite dépassé.";
                          $this->_helper->viewRenderer('errorsouscription');        
                          return;
            }
        }
        
        $this->_session->_ctTimeOut=  mktime();

        $idwos=$this->getRequest()->getParam("idsous")?$this->getRequest()->getParam("idsous"):null;
        $idwo=$this->getRequest()->getParam("idoffre")?$this->getRequest()->getParam("idoffre"):null;
        $produit=$this->getRequest()->getParam("pdt")?$this->getRequest()->getParam("pdt"):null;
        $etape=$this->getRequest()->getParam("etape")?$this->getRequest()->getParam("etape"):"init";
        $isBack=$this->getRequest()->getParam("isback")?$this->getRequest()->getParam("isback"):null;
        //mise en session du produit pout toute la durée de commercialisation
        $this->view->pdt=$produit;

        //Zend_Debug::dump($tab,"tableau param factorisé");
        //Zend_Debug::dump( $this->_session->_produit,"session produit");
        switch ($etape) {
                case "init":
                    //mise en session etape precedente poue etape 2 back
                    $this->_session->_etapePrec="init";
                    // gestion bt back
                    if($isBack){
                        // dans back idwos existe
                        $idwos=$this->getRequest()->getParam("idsous");
                    }else{
                         // zero etant pour l'init debut d'une souscription
                        $idwos=0;
                    }
                    
                    //ps to get form init
                    $stmt = $this->_db->prepare("execute ps_ExtWFormCtInit @idgrgc='$this->_idBzUser',@idwos=$idwos,@idwo=$idwo,@ip='$this->_ip'");
                       try{
                            $stmt->execute();
                            $result=$stmt->fetchAll();
                           }catch(Zend_Exception $e){

                            echo $e->getMessage();
                          }

                        if($result[0]['erreur']){
                            /**
                             * @todo traitement erreur voir si la liste peux etre vide ??????
                             */
                        }else{

                            $xml=$result[0][""];

                        }

                    $this->view->data=new SimpleXMLElement($xml);
               
                        try{
                           $this->view->formData=Zend_Json::fromXml($xml,false); 
                        }  catch (ErrorException $e){

                            //Zend_Debug::dump($result);
                            //Zend_Debug::dump($e);
                        }

                        //Zend_Debug::dump($result,"ps_ExtWFormCtInit ");
                break;
                /**
                 * produit derivés
                 */
            case "1":
                
                    $this->_session->_etapePrec="1";
                    //param post
                   $struct=$this->getRequest()->getParam("stru")?$this->getRequest()->getParam("stru"):null;
                   $exec=$this->getRequest()->getParam("exec")?$this->getRequest()->getParam("exec"):null;
                   $silo=$this->getRequest()->getParam("silo")?$this->getRequest()->getParam("silo"):null;
                   $depart=$this->getRequest()->getParam("exec")?"depart":"rendu";
                   $periode=$this->getRequest()->getParam("periode")?$this->getRequest()->getParam("periode"):null;
                   $pobs=$this->getRequest()->getParam("pobs")?$this->getRequest()->getParam("pobs"):0;
                   $paiement=$this->getRequest()->getParam("paiement")?$this->getRequest()->getParam("paiement"):null;
                   //Zend_Debug::dump($depart,"depart");
                    // validation etape Init
                   //ps_ExtWFormCtInitVal  @idgrgc, @idwo, @idwos, @idti, @idexe, @ip
                   $stmt = $this->_db->prepare("execute ps_ExtWFormCtInitVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@idwocld='$periode',@idwob='$pobs',@idwopa='$paiement',@idti='$struct',@rd='$depart',@idexe='$exec',@idsil='$silo',@ip='$this->_ip'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }
                   /**
                    * @todo gestion erreur validation
                    */
                      
                   // chargement des produits
                  $stmt = $this->_db->prepare("execute ps_ExtWFormCtPdts @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@ip='$this->_ip'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }
                      
                    if($result[0]['erreur']){
                        /**
                         * @todo traitement erreur voir 
                         */
                    }else{

                        $xml=$result[0][""];

                    }
                   //Zend_Debug::dump($result);
                   $this->view->back="init";
                   $this->view->data=new SimpleXMLElement($xml);
                 
                   $this->_helper->viewRenderer('etape1'); 
                break;
            /*
             *  Calcul du prix
             */
            case "2":
             //param post
                   $struct=$this->getRequest()->getParam("stru")?$this->getRequest()->getParam("stru"):null;
                   $exec=$this->getRequest()->getParam("exec")?$this->getRequest()->getParam("exec"):"0";
                   $silo=$this->getRequest()->getParam("silo")?$this->getRequest()->getParam("silo"):null;
                   $depart=$this->getRequest()->getParam("exec")?"depart":"rendu";
                    $periode=$this->getRequest()->getParam("periode")?$this->getRequest()->getParam("periode"):null;
                   $pobs=$this->getRequest()->getParam("pobs")?$this->getRequest()->getParam("pobs"):0;
                   $paiement=$this->getRequest()->getParam("paiement")?$this->getRequest()->getParam("paiement"):null;
                   //Zend_Debug::dump($depart,"depart");
                   //param opti / secu 
                   $optidwohb=$this->getRequest()->getParam("optimiz")?$this->getRequest()->getParam("optimiz"):null;
                   $secidwohb=$this->getRequest()->getParam("securiz")?$this->getRequest()->getParam("securiz"):null;
                  
                   //param bt back
                   /**
                    * @todo voir a mettre en session 
                    */
                   $this->view->back=$this->_session->_etapePrec;
                   
                   if(!$isBack){

                       if($this->_session->_etapePrec=="init"){
                            // validation etape Init
                      
                                $stmt = $this->_db->prepare("execute ps_ExtWFormCtInitVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@idwocld='$periode',@idwob='$pobs',@idwopa='$paiement',@idti='$struct',@rd='$depart',@idexe='$exec',@idsil='$silo',@ip='$this->_ip'");
                           
                               try{
                                    $stmt->execute();
                                    $result=$stmt->fetchAll();
                                   }catch(Zend_Exception $e){
                                       /**
                                        * traitement des erreures
                                        */
                                    
                                  }
                               /**
                                * @todo gestion erreur validation
                                */
                       }else{
                           //  from produit dérivés
                           $stmt = $this->_db->prepare("execute ps_ExtWFormCtPdtsVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@optidwohb='$optidwohb',@secidwohb='$secidwohb',@ip='$this->_ip'");
                               try{
                                    $stmt->execute();
                                    $result=$stmt->fetchAll();
                                   }catch(Zend_Exception $e){
                                       /**
                                        * traitement des erreures
                                        */
                                    
                                  }
                                  
                                  //Zend_Debug::dump($result,"ps_ExtWFormCtPdtsVal");
                       }
                   
                   }
                    // prix
                    $stmt = $this->_db->prepare("execute ps_ExtWFormCtPx @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@idexe='$exec',@ip='$this->_ip'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }
                      
                    if($result[0]['erreur']){
                        /**
                         * @todo traitement erreur voir 
                         */
                    }else{
                        $xml=$result[0][""];
                    }
                   //Zend_Debug::dump($result);
                   $this->view->data=new SimpleXMLElement($xml);
                   
                  
                   
                   
                   //gestion contrat cas particulier
                   //Zend_Debug::dump($produit,"produit");
                   switch ( $produit) {
                       case "bzenith":
                            $this->_helper->viewRenderer('etape2bzenith');
                            $this->view->etapeprec='etape2bzenith';
                           break;

                       default:
                            $this->_helper->viewRenderer('etape2');
                            $this->view->etapeprec='2';
                           break;
                   }
                   

                break;
            // recap
            case "3":           
                    //validation du prix 
                    //param post
                    $prix=$this->getRequest()->getParam("px")?$this->getRequest()->getParam("px"):null;
                    $date=$this->getRequest()->getParam("date")?$this->getRequest()->getParam("date"):null;
                    $heure=$this->getRequest()->getParam("heure")?$this->getRequest()->getParam("heure"):null;
                    $formAddLot=$this->getRequest()->getParam("form")?$this->getRequest()->getParam("form"):null;
                    
                    $etapeBack=$this->getRequest()->getParam("etapeprec");
                    
                    //concatenation date
                    $date= $date." ".$heure;
                    
                    //Zend_Debug::dump($date,"date");
                   
                    $this->view->back=$etapeBack;
                    
                        // check si ca viens du formulaire ajout de lot ou si c'est un back
                        if(!$formAddLot && !$isBack){
                            $stmt = $this->_db->prepare("execute ps_ExtWFormCtPxVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@px='$prix',@date='$date',@ip='$this->_ip'");
                                   try{
                                        $stmt->execute();
                                        $result=$stmt->fetchAll();
                                       }catch(Zend_Exception $e){
                                           /**
                                            * traitement des erreures
                                            */
                                        echo $e->getMessage();
                                      }
                        }
                    
                   // chargement form recap +engagement    
                   $stmt = $this->_db->prepare("execute ps_ExtWFormCtQte @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@ip='$this->_ip'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }
                      
                    if($result[0]['erreur']){
                        /**
                         * @todo traitement erreur voir 
                         */
                    }else{

                        $xml=$result[0][""];

                    }
                   
                    //Zend_Debug::dump($result,"ps_ExtWFormCtQte");
                    
                   $this->view->data=new SimpleXMLElement($xml);

                   $this->_helper->viewRenderer('etape3'); 

                break;
                // etape recapitulatif
            case "4":

                   $qteEng=$this->getRequest()->getParam("qte")?$this->getRequest()->getParam("qte"):"0";
                   $qteGlob=$this->getRequest()->getParam("qteglob")?$this->getRequest()->getParam("qteglob"):"0";
                   $auto=$this->getRequest()->getParam("auto")?$this->getRequest()->getParam("auto"):null;
                   $ha=$this->getRequest()->getParam("ha")?$this->getRequest()->getParam("ha"):null;
                   $lots=$this->getRequest()->getParam("checkLot");
                   $this->view->back="3";
    
                   if(!$isBack){
                       //Zend_debug::dump($isBack,"isBack");
                        //itere les lots pour les concaténer dans une chaine
                        //chaine pour stock ferme
                        $strLots="";
                        //chaine pour depot
                        $strDep="";
                        if($lots && is_array($lots))
                        {    

                            foreach ($lots as $value) {
                                //Zend_debug::dump($value,"value");

                                    if($value=="") continue;
                                    $tab= explode("_",$value );
                                    //Zend_Debug::dump($tab,"tab");
                                    if(!preg_match("/dep/i", $tab[0])){
                                        $strLots.=$tab[1].";".round($tab[2],2).";"; 
                                    }else{
                                        $strDep.=$tab[1].";".round($tab[2],2).";"; 
                                    }
                                    
                                    
                            }
                            
                            //retire le dernier ;
                            $strLots=substr($strLots,0,-1);
                            $strDep=substr($strDep,0,-1);
                        }
                        
                        //Zend_debug::dump($strLots,"strLots");
                        //Zend_debug::dump($strDep,"strDep");
                        
                        
                         
                           $stmt = $this->_db->prepare("execute ps_ExtWFormCtQteVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@criteresf='$strLots',@criteresd='$strDep',@qte='$qteEng',@auto='$auto',@qteglob='$qteGlob',@ha='$ha',@ip='$this->_ip'");
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                                //Zend_Debug::dump($result,"result engagement");
                               }catch(Zend_Exception $e){
                                   /**
                                    * traitement des erreures
                                    */
                                echo $e->getMessage();
                              }
                       }
                       
                          // load recapitulatif
                          $stmt = $this->_db->prepare("execute ps_ExtWFormCtRecap @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@ip='$this->_ip'");
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                               }catch(Zend_Exception $e){
                                   /**
                                    * traitement des erreures
                                    */
                                echo $e->getMessage();
                              }
                            //Zend_Debug::dump($result,"result recap");
                            if($result[0]['erreur']){
                                /**
                                 * @todo traitement erreur voir 
                                 */
                            }else{
                                $xml=$result[0][""];
                            }

                    $this->view->data=new SimpleXMLElement($xml);

                    $this->_helper->viewRenderer('etape4'); 

                break;
                // confirmation
                case "5":
                        
                        $this->view->back="4";
                       
                           $stmt = $this->_db->prepare("execute ps_ExtWFormCtRecapVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@ip='$this->_ip'");
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                               }catch(Zend_Exception $e){
                                   /**
                                    * traitement des erreures
                                    */
                                echo $e->getMessage();
                              }
                           
                              if($result[0]['erreur']){
                                /**
                                 * @todo traitement erreur voir 
                                 */


                                }else{

                                    $xml=$result[0][""];

                                }

                    //get condition de ventes
                   /* $cdv= file_get_contents('../public/conditionsDeVentes/conditionsDeVentes.txt', FILE_USE_INCLUDE_PATH);
                    $this->view->cdv=$cdv;*/
                    $this->view->data=new SimpleXMLElement($xml);
                        $this->_helper->viewRenderer('etape5'); 
                    break;
                // validation souscription
                case "validation": 
                    
                        // vide session etape prec
                        unset($this->_session->_etapePrec);
                        unset($this->_session->_produit);
                        //check data 
                        //$cdvChecked=$this->getRequest()->getParam("cdv")?$this->getRequest()->getParam("cdv"):null;
                        $pwd=$this->getRequest()->getParam("pwd")?$this->getRequest()->getParam("pwd"):null;

                        if(!$pwd){
                            $this->view->error="pwdEmpty";
                            $this->view->message="Votre mot de passe n'est pas renseigné, veuillez essayer à nouveau.<br/>Si le problème persite contactez votre agent commercial.";
                            $this->view->title="Erreur mot de passe.";
                            $this->_helper->viewRenderer('errorsouscription'); 
                            return;
                        }
                        
                       /* if(!$cdvChecked){
                            $this->view->error="chk";
                            $this->view->message="Vous devez valider conditions générales d'achats, avant de poursuivre";
                            $this->view->title="Erreur conditions générales d'achats.";
                            $this->_helper->viewRenderer('errorsouscription');
                            return;
                        }*/
                        
                        $pwd=  md5($pwd);
                        //ps_ExtWFormCtVal @idgrgc, @idwos,@idwo,@pwd @ip
                           $stmt = $this->_db->prepare("execute ps_ExtWFormCtVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@pwd='$pwd',@login='$this->_bzUser',@ip='$this->_ip'");
                           
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                               }catch(Zend_Exception $e){
                                   /**
                                    * traitement des erreures
                                    */
                                   $this->_helper->LogProduit(array("level"=>"alert","message"=>'erreur commercialisation<br/> retour sql Erreur',"PS"=>"ps_ExtWFormCtVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@pwd='$pwd',@login='$this->_bzUser',@ip='$this->_ip'","email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
            
                                echo $e->getMessage();
                              }
                              
                              //Zend_Debug::dump($result,"ps_ExtWFormCtVal");
                              /**
                               * si erreur different de 0
                               */
                              if($result[0]['erreur']){
                                /**
                                 * @todo traitement erreur voir 
                                 */
                                  //Zend_Debug::dump($result[0]['erreur'],"error retour");
                                  $this->view->title="Erreur";
                                  //</br>Vous allez être automatiquement redirigé.</br>Toutes nos excuses pour ce désagrément.<br/>
                                  switch ($result[0]['erreur']) {
                                      // pwd error
                                      case "2":
                                          $this->view->message="Erreur mot de passe, vous avez trois tentatives maximum, avant que votre compte ne soit interrompu.</br>Si le problème persiste contactez Votre agent commercial.";
                                          $this->view->error="pwd";

                                          break;

                                      default:
                                             $this->_helper->LogProduit(array("level"=>"alert","message"=>'erreur commercialisation<br/> retour sql Erreur',"erreur"=>"$result[0]['erreur']['msgerreur']","email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
                                            // vide session etape prec
                                            unset($this->_session->_etapePrec);
                                            //vide time out
                                            unset($this->_session->_ctTimeOut);
                                           $stmt=$this->_db->prepare("execute ps_ExtWFormCtDel @idgrgc='$this->_idBzUser',@idwos=$idwos,@ip='$this->_ip'");
                                           $stmt->execute();
                                           $this->view->message="Une erreur est survenu.</br>Si le problème persiste contactez Votre agent commercial.";
                                           $this->view->error="autre";
                                          break;
                                  }
                                   
                                   $this->_helper->viewRenderer('errorsouscription');
                                   return;


                                }else{
                                    
                                    //Zend_Debug::dump($result,"sql ps_ExtWFormCtVal");
                                    $this->view->message="</br>Votre contrat a bien été enregistré.</br>Vous allez être automatiquement redirigé.</br>Merci de votre confiance.<br/>";
                                    $this->view->title="Confirmation";
                                    $this->_helper->viewRenderer('validationct');
                                    
                                    //Zend_Debug::dump($result[0][""]);
                                    
                                    $pdfCreate=$this->pdfCreate($xmlSX=new SimpleXMLElement($result[0][""]), "", "");
                                    
                                    $this->sendConfirm($this->_bzUser,"confirmation contractualisation", null,$pdfCreate,null);
                                   
                                   
                                    $this->view->numtran=$xmlSX->numtran;
                                    //$this->_helper->viewRenderer('errorsouscription');
                                    return;

                                }

                    break;
            default:
                    $this->_forward("offres");
                    exit();
                break;
        }
  
    }
    
    public function annuleformctAction(){
         //vide time out
         unset($this->_session->_ctTimeOut);
         // vide session etape prec
         unset($this->_session->_etapePrec);
         $this->_helper->layout->disableLayout();
         $this->_helper->viewRenderer->setNoRender(TRUE); 
         $idwos=$this->getRequest()->getParam("idsous");
         $stmt=$this->_db->prepare("execute ps_ExtWFormCtDel @idgrgc='$this->_idBzUser',@idwos=$idwos,@ip='$this->_ip'");
         $stmt->execute();
    }
    
    /**
     * formulaire ajout de lot 
     */
     public function addlotAction(){
                // envoyer idwo et idwos a partir d'ajouter lot manu pour retour
                $idWos=$this->getRequest()->getParam("idwos");
                $idWo=$this->getRequest()->getParam("idwo");
                $this->view->idwos=$idWos;
                $this->view->idwo=$idWo;
                //$stmt = $this->_db->prepare("execute ps_ExtWFormLot @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
                $stmt = $this->_db->prepare("execute ps_ExtWFormLotSAuto @idgrgc='$this->_idBzUser',@idwos='$idWos',@idwo='$idWo',@ip='$this->_ip'"); 
                
                //ps_ExtWFormLotSAuto] @idgrgc,@idwos, @idwo, @ip
                
                try {
                        $stmt->execute();
                        $resultXml=$stmt->fetchAll();

                        } catch (Exception $exc) {
                            echo $exc->getTraceAsString();
                        }
                        
                        //Zend_Debug::dump($resultXml,"ps_ExtWFormLotSAuto");
                        

                        $xml=$resultXml[0][""];
                        
                        
                        
                        $this->view->formData=Zend_Json::fromXml($xml,false);

                        //si le Xml est null
                        /**
                         *@todo voir le cas du xml null voir si afcher bt addlot 
                         */
                        if(!$xml){
                                //Zend_Debug::dump($resultXml[0][""]);
                                $this->_helper->redirector('index','administration');
                                exit();
                            }
                            //Zend_Debug::dump($xml);
                            $xml=new SimpleXMLElement($xml);
                           
            $this->view->formLotXml=$xml;

        
    }
    
    public function validatecontratAction(){
        
        $idwo=$this->getRequest()->getParam("idOffre");
        $idti=$this->getRequest()->getParam("stru");
        $idex_Prixexe=$this->getRequest()->getParam("exec");
        $idex=  explode("_",$idex_Prixexe);
        $idex=$idex[0];
        $prixex=  explode("_",$idex_Prixexe);
        $prixex=$prixex[1];
        $prix=$this->getRequest()->getParam("prix");
        $stckdp=$this->getRequest()->getParam("stck");
        $qte=$this->getRequest()->getParam("qteng");
        $opt=$this->getRequest()->getParam("optimiz")?$this->getRequest()->getParam("optimiz"):0;
        $secu=$this->getRequest()->getParam("securiz")?$this->getRequest()->getParam("securiz"):0;
        $pwd=  md5($this->getRequest()->getParam("pwd"));
        
        $test=$idwo."/".$idti."/".$idex."/".$stckdp."/".$qte."/".$opt."/".$secu."/".$pwd."/".$prix;
        //Zend_Debug::dump($test);
     
        // ps valide souscription
         $stmt = $this->_db->prepare("execute ps_ExtWSouscrAdd @idgrgc='$this->_idBzUser',@idwo=$idwo,@idwopx=$prixex,@idti=$idti,@idex=$idex,@stckdep='$stckdp',@qte=$qte,@idopt='$opt',@idsecu='$secu',@pwd='$pwd',@prix=$prix,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
           
            //Zend_Debug::dump($result,"result SouscrAdd from sql");
           
           /**
             * traitement erreur retour sql
             */
            if($result[0]['erreur']){
                
                $this->_forward("getcontrats",null,null,array("format"=>"html","message"=>$result[0]['msgerreur']));
                
                
            }else{
                //redirige vers list
                //$this->_forward("getcontrats",null,null,array("format"=>"html"));
            }
        
       
      
            
    }
    
    public function infoAction(){
        
         // get application.ini data bz
            $fc = Zend_Controller_Front::getInstance();
            $arrOptions = $fc->getParam("bootstrap")->getOptions();
            
            $bzinit=$arrOptions['bzinit'];
            
            $this->view->urlAide=$bzinit['url_aide'];
            
            // get url param
            
           
            $this->view->idpage= $this->getRequest()->getParam("idpage");
        
    }
    
    public function getcontrattolockAction(){
        
        if(!$this->_acl->isAllowed($this->_role,'transaction','getcontrattolock')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        
        

        $this->view->action="getcontrattolock";
        $this->view->message=$this->getRequest()->getParam("message");
        
        $contrat=$this->getRequest()->getParam("contrat");
        //$contrat=  strtolower($contrat[1]);
        //$contrat=$this->getRequest()->getParam("param");
        $contrat= preg_replace("/ /", "", $contrat);
        
         $stmt = $this->_db->prepare("execute ps_ExtWPOffresUnlock  @idgrgc='$this->_idBzUser',@code='$contrat',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
              
        
              
           
            //Zend_Debug::dump($result,"result from sql ps_ExtWPOffresUnlock");
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
                $this->_data='<cellules>
                                <cellule titre="error data " img=""></cellule>
                                <cellule titre="error data" img=""></cellule>
                             </cellules>';
            }else{
                /**
                *@todo faire tres attention car se base sur nom du xml comme une chaine vide 
                * il serait bien de regler se problème, pour etre sur que cela ne pose pas
                * de soucis pour le suite. 
                */
                $this->_data=$result[0][""];
            }
            
            //Zend_Debug::dump($this->_data,"data brutes");

            $xml=new SimpleXMLElement($this->_data);
            //Zend_Debug::dump($xml);
            //$this->view->data= $this->_data;
            $this->view->data= $xml;
            //return;
            try{
               $this->view->dataJson=Zend_Json::fromXml($this->_data,false); 
                
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
        
    }
    
    function getdetailcontratAction(){
        
        if(!$this->_acl->isAllowed($this->_role,'transaction','getdetailcontrat')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="getdetailcontrat";
        $contrat=$this->getRequest()->getParam("contrat")?$this->getRequest()->getParam("contrat"):null;

        /**
         * permet de recuperer le nom de la cellule appelante afin de 
         * determiner qu"elle données affichées dans le detail cellules
         * ser aussi au titre
         */
        $this->view->contratName=strtoupper($contrat);
        
        $stmt = $this->_db->prepare("execute ps_ExtWTContrats @idgrgc='$this->_idBzUser',@code=$contrat,@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
                   
              }
              
               if($result[0]['erreur'] || is_null($result[0][""])){
                   
                   throw new Zend_Exception("erreur sql : ".$result[0]['erreur']." is_null :".is_null($result[0][""]));
                
               // case pas de donné sql return ""
               }elseif($result[0][""]==""){
                   
                   $this->_data="<contrats></contrats>";
                   
               }else{
                    /**
                    *@todo faire tres attention car se base sur nom du xml comme une chaine vide 
                    * il serait bien de regler se problème, pour etre sur que cela ne pose pas
                    * de soucis pour le suite. 
                    */
                    $this->_data=$result[0][""];
                }
              //Zend_Debug::dump($result,"result from ps_ExtWTContrats ");
              
              
        
        // call gdataglobal
        $dataCell=$this->_helper->Getglobal($this->_db,"TRA",$this->_filter);
        //Zend_Debug::dump($dataCell,"datacell from getglobal");
    
        //Zend_Debug::dump($_gData,"gdata");
        
        try{
               $this->view->siloData=$dataCell;
               $this->view->data=Zend_Json::fromXml($this->_data,false); 
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result,"erreur zend json from xlm");
                //Zend_Debug::dump($e);
                /**
                 * @todo gestion error
                 */
            }
        
        
    }
    
    /**
     * bloc le prix du contrat
     */
    public function setblocprixAction(){
        
        if(!$this->_acl->isAllowed($this->_role,'transaction','setblocprix')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        $idct=$this->getRequest()->getParam("idct");
        $idchb=$this->getRequest()->getParam("idchb")?$this->getRequest()->getParam("idchb"):"null";
        $produit=$this->getRequest()->getParam("pdt")?$this->getRequest()->getParam("pdt"):"";
        /**
         * control erreur parametre inexistants
         * 
         */
        
        //Zend_Debug::dump($produit,"produit");
        
        if(!isset($idchb) || !isset($idct)){
            /**
             * @todo gestion erreur , redirection page erreur
             */
            //Zend_Debug::dump($idchb,"un des parametre d'entré est manquant");
            return;
        }
        //ps to get form
        $stmt = $this->_db->prepare("execute ps_ExtWFormContratLock @idgrgc='$this->_idBzUser',@idct=$idct,@idchb=$idchb,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
           
            //Zend_Debug::dump($result,"result ps_ExtWFormContratLock");
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
                
            }else{
                
                $xml=$result[0][""];
               
            }
        
        //get condition de ventes
        /*$cdv= file_get_contents('../public/conditionsDeVentes/conditionsDeVentes.txt', FILE_USE_INCLUDE_PATH);
        
        $this->view->cdv=$cdv;*/
        
        
   
        
        $this->view->data=new SimpleXMLElement($xml);
        $this->view->produit=$produit;
        //$this->view->data=$xml;
        //Zend_Debug::dump($this->view->data);
            
            try{
               $this->view->formData=Zend_Json::fromXml($xml,false); 
              // $this->view->formData=Zend_Json::fromXml(new SimpleXMLElement($xml),false); 
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
        
        
    }
    
    public function validateblockAction(){
        
        //Zend_Debug::dump($this->getRequest()->getPost(),"parametre post");
        $idct=$this->getRequest()->getParam("idct");
        $idchb=$this->getRequest()->getParam("idchb")?$this->getRequest()->getParam("idchb"):0;
        //$pwd=  md5($this->getRequest()->getParam("pwd"));
        $qteha=  $this->getRequest()->getParam("qteha");
        
        
         //$cdvChecked=$this->getRequest()->getParam("cdv")?$this->getRequest()->getParam("cdv"):null;
        $pwd=$this->getRequest()->getParam("pwd")?md5($this->getRequest()->getParam("pwd")):null;

        if(!$pwd){
            $this->view->error="pwdEmpty";
            $this->view->message="Votre mot de passe n'est pas renseigné, veuillez essayer à nouveau.<br/>Si le problème persite contactez votre agent commercial.";
            $this->view->title="Erreur mot de passe.";
            $this->_helper->viewRenderer('errorsouscription'); 
            return;
        }
        /*if(!isset($idchb) || !isset($idct)){
           
            Zend_Debug::dump(!isset($idchb),"un des parametre d'entré est manquant");
            return;
        }*/
        $optParams="";
        // parametre optionnels
        if(count($this->getRequest()->getPost())>0)
        {
            
            $len=count($this->getRequest()->getPost());
            $i=0;
            foreach ($this->getRequest()->getPost() as $key => $value) {

                    // soustrait les parametres obligatoires
               
                   if($key=="idct"|| $key=="idchb" || $key=="pwd" || $key=="pdt" || $key=="qteha") continue;
                 
                   //last
                   if($i=$len-1){
                       $optParams.=",@".$key."='".$value."'";
                   }else{
                       
                       $optParams.=",@".$key."='".$value."',";
                   }

                 $i++;  
            }
        }
        
       // Zend_debug::dump($optParams,"les parametres");
        /**
         * ATTENTION cette PS est en partie construite dynamiquement
         * dans le xml genéré par la ps_ExtWFormContratLock tous les champs non obligatoires avec l'atrtribut "retour" et "pname"
         * seront renvoyés comme parametre de la ps avec comme nom d'attribut "pname" et la valeur "value"
         * attention a lordre des champs 
         */
        //ps to get form
        $stmt = $this->_db->prepare("execute ps_ExtWPOffresBlock @idgrgc='$this->_idBzUser',@idct=$idct,@idchb=$idchb,@qteha='$qteha',@pwd='$pwd',@ip='$this->_ip',@login='$this->_bzUser'".$optParams);
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                echo $e->getMessage();
              }
        
           
   
                              //Zend_Debug::dump($result,"ps_ExtWOPtiVal");
                              /**
                               * si erreur different de 0
                               */
                              if($result[0]['erreur']){
                                /**
                                 * @todo traitement erreur voir 
                                 */
                                  //Zend_Debug::dump($result[0]['erreur'],"error retour");
                                  $this->view->title="Erreur";
                                  //</br>Vous allez être automatiquement redirigé.</br>Toutes nos excuses pour ce désagrément.<br/>
                                  switch ($result[0]['erreur']) {
                                      // pwd error
                                      case "2":
                                          $this->view->message="Erreur mot de passe, vous avez trois tentatives maximum, avant que votre compte ne soit interrompu.</br>Si le problème persiste contactez Votre agent commercial.";
                                          $this->view->error="pwd";

                                          break;

                                      default:
                                             $this->_helper->LogProduit(array("level"=>"alert","message"=>'erreur commercialisation optimiz<br/> retour sql Erreur',"erreur"=>"$result[0]['erreur']['msgerreur']","email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
                                            // vide session etape prec
                                            unset($this->_session->_etapePrec);
                                            //vide time out
                                            unset($this->_session->_ctTimeOut);
                                           $this->view->message="Une erreur est survenu.</br>Si le problème persiste contactez Votre agent commercial.";
                                           $this->view->error="autre";
                                          break;
                                  }
                                   
                                   $this->_helper->viewRenderer('errorsouscription');
                                   return;


                                }else{
                                    
                                    
                                    //Zend_Debug::dump($result,"sql ps_ExtWFormCtVal");
                                    $this->view->message="</br>Votre contrat a bien été enregistré.</br>Vous allez être automatiquement redirigé.</br>Merci de votre confiance.<br/>";
                                    $this->view->title="Confirmation";
                                    $this->_helper->viewRenderer('validateblock');
                                    
                                    $pdfCreate=$this->pdfCreate($xmlSX=new SimpleXMLElement($result[0][""]), "", "");
                       
                                    $this->sendConfirm($this->_bzUser,"confirmation contractualisation",null,$pdfCreate,null);
                                    
                                    $this->view->numtran=$xmlSX->numtran;
                                    return;

                                }
    }
    
    /**
     * @uses  Description liste des optimiz à bloquer
     */
    public function getoptimisesAction(){
        
         if(!$this->_acl->isAllowed($this->_role,'transaction','getoptimises')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
         $this->view->action="getoptimises";
         $this->view->message=$this->getRequest()->getParam("message");
         
         $typeCt=$this->getRequest()->getParam("typeCt");
         
         $this->view->typeCt=$typeCt;
         
         $stmt = $this->_db->prepare("execute ps_ExtWTCtsCouv @idgrgc='$this->_idBzUser',@code=$typeCt,@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                
                echo $e->getMessage();
              }
        
              if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
                
            }else{
                
                $this->_data=$result[0][""];
               
            }
            //Zend_Debug::dump($result,"result extExtWTCtsCouv from sql");
            
            $dataCell=$this->_helper->Getglobal($this->_db,"TRA",$this->_filter);
            
            
            $this->view->siloData=$dataCell;

        $this->view->dataJson=Zend_Json::fromXml($this->_data,false); 
       
       
        
    }
    
    public function getoffreoptiAction(){
        
         if(!$this->_acl->isAllowed($this->_role,'transaction','getoffreopti')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="getoptisous";
        $this->view->message=$this->getRequest()->getParam("message");
        // ps offre opti
        
        //ps_ExtWFormOptiList @idgrgc, @ip
        $stmt = $this->_db->prepare("execute ps_ExtWFormOptiList @idgrgc='$this->_idBzUser',@ip='$this->_ip',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                
                echo $e->getMessage();
              }
        
              if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
                
            }else{
                
                $this->_data=$result[0][""];
               
            }
            //Zend_Debug::dump($result,"result ps_ExtWFormOptiList from sql");

        
        try{
               $this->view->dataJson=Zend_Json::fromXml($this->_data,false); 
                
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
        
        
    }
    
    public function setoptiAction(){
        
        if(!$this->_acl->isAllowed($this->_role,'transaction','setopti')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
           // check timeOut pour la souscription formulaire
        if($this->_session->_ctTimeOut){
            
            $now=  mktime();
            if($now-$this->_session->_ctTimeOut>$this->time){
                // play cancel
                          unset($this->_session->_ctTimeOut);
                          $idwos=$this->getRequest()->getParam("idsous");
                          $stmt=$this->_db->prepare("execute ps_ExtWFormOpDel @idgrgc='$this->_idBzUser',@idwos=$idwos,@ip='$this->_ip'");
                          $stmt->execute();
                          // tpsover = a default dans switch js
                          $this->view->error="opti";
                          $this->view->message="Vous avez dépassé le temps limite(15mn) pour votre souscription, veuillez recommencer";
                          $this->view->title="Erreur temps limite dépassé.";
                          $this->_helper->viewRenderer('errorsouscription');        
                          return;
            }
        }
        
        $this->_session->_ctTimeOut=  mktime();
        $etape=$this->getRequest()->getParam("etape")?$this->getRequest()->getParam("etape"):null;
        $idWo=$this->getRequest()->getParam("idwo");
        $idWohb=$this->getRequest()->getParam("idwohb");
        //$isBack=$this->getRequest()->getParam("isback")?$this->getRequest()->getParam("isback"):null;
       
        
        $this->view->idwo=$idWo;
        $this->view->idwohb=$idWohb;
        
//        if($isBack){
//            $etape=$this->getRequest()->getParam("etapeprec");
//        }
        //Zend_Debug::dump($idWo,"idwo");
        //Zend_Debug::dump($idWohb,"idwohb");
        switch ($etape) {
            case "init":

                //ps to get form init
                    $stmt = $this->_db->prepare("execute ps_ExtWOptiInit @idgrgc='$this->_idBzUser',@idwohb=$idWohb,@idwo=$idWo,@ip='$this->_ip'");
                       try{
                            $stmt->execute();
                            $result=$stmt->fetchAll();
                           }catch(Zend_Exception $e){

                            echo $e->getMessage();
                          }

                        if($result[0]['erreur']){
                            /**
                             * @todo traitement erreur voir si la liste peux etre vide ??????
                             */


                        }else{

                            $xml=$result[0][""];

                        }
                        
                        //Zend_Debug::dump($xml,"ps_ExtWOptiInit");


                    //$this->view->data=new SimpleXMLElement($xml);


                break;
             case "etape1":
               
                      $lots=$this->getRequest()->getParam("checkLot");
                     //chaine pour stock ferme
                        $strLots="";
                        
                        if($lots && is_array($lots))
                        {    

                            foreach ($lots as $value) {
                                //Zend_debug::dump($value,"value");

                                    if($value=="") continue;
                                    $tab= explode("_",$value );
                                    //Zend_Debug::dump($tab,"tab");
                                        $strLots.=$tab[0].";".round($tab[1],2).";".round($tab[2],2).";"; 
     
                            }
                            
                            //retire le dernier ;
                            $strLots=substr($strLots,0,-1);
                            
                        }
                        
                        
                        //Zend_Debug::dump($strLots,"lots");
                        
                        
                 //ps_ExtWOPtiInitVal @idgrgc INTEGER, @idwo INT, @idwohb INT, @criteresct VARCHAR(500), @ip
                     $stmt = $this->_db->prepare("execute ps_ExtWOPtiInitVal @idgrgc='$this->_idBzUser',@idwohb=$idWohb,@idwo=$idWo,@criteresct='$strLots',@ip='$this->_ip'");
                       try{
                            $stmt->execute();
                            $result=$stmt->fetchAll();
                           }catch(Zend_Exception $e){

                            echo $e->getMessage();
                          }

                        if($result[0]['erreur']){
                            /**
                             * @todo traitement erreur voir si la liste peux etre vide ??????
                             */


                        }else{

                            $result=$result[0][""];

                        }
                 $xml=null;
                    //Zend_Debug::dump($result,"ps_ExtWOPtiInitVal");

                    //$this->view->back="etape1";
                    $this->view->idwos=$result;
                    $this->_helper->viewRenderer('setoptietape1'); 
                break;
            
                
             case "validation":
                     $idWos=$this->getRequest()->getParam("idwos");
                     $pwd=$this->getRequest()->getParam("pwd")?$this->getRequest()->getParam("pwd"):null;

                        if(!$pwd){
                            $this->view->error="pwdEmpty";
                            $this->view->message="Votre mot de passe n'est pas renseigné, veuillez essayer à nouveau.<br/>Si le problème persite contactez votre agent commercial.";
                            $this->view->title="Erreur mot de passe.";
                            $this->_helper->viewRenderer('errorsouscription'); 
                            return;
                        }
                        
                       /* if(!$cdvChecked){
                            $this->view->error="chk";
                            $this->view->message="Vous devez valider conditions générales d'achats, avant de poursuivre";
                            $this->view->title="Erreur conditions générales d'achats.";
                            $this->_helper->viewRenderer('errorsouscription');
                            return;
                        }*/
                        
                        $pwd=  md5($pwd);
                        
                        //ps_ExtWOPtiVal @idgrgc INTEGER, @idwos INT,@pwd char(34),@login char(50), @ip
                           $stmt = $this->_db->prepare("execute ps_ExtWOPtiVal @idgrgc='$this->_idBzUser',@idwos='$idWos',@pwd='$pwd',@login='$this->_bzUser',@ip='$this->_ip'");
                           
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                               }catch(Zend_Exception $e){
                                   /**
                                    * traitement des erreures
                                    */
                                   $this->_helper->LogProduit(array("level"=>"alert","message"=>'erreur commercialisation<br/> retour sql Erreur',"PS"=>"ps_ExtWFormOpVal @idgrgc='$this->_idBzUser',@idwos='$idwos',@idwo='$idwo',@pwd='$pwd',@login='$this->_bzUser',@ip='$this->_ip'","email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
   
                              }
                              
                              //Zend_Debug::dump($result,"ps_ExtWOPtiVal");
                              /**
                               * si erreur different de 0
                               */
                              if($result[0]['erreur']){
                                /**
                                 * @todo traitement erreur voir 
                                 */
                                  //Zend_Debug::dump($result[0]['erreur'],"error retour");
                                  $this->view->title="Erreur";
                                  //</br>Vous allez être automatiquement redirigé.</br>Toutes nos excuses pour ce désagrément.<br/>
                                  switch ($result[0]['erreur']) {
                                      // pwd error
                                      case "2":
                                          $this->view->message="Erreur mot de passe, vous avez trois tentatives maximum, avant que votre compte ne soit interrompu.</br>Si le problème persiste contactez Votre agent commercial.";
                                          $this->view->error="pwd";

                                          break;

                                      default:
                                             $this->_helper->LogProduit(array("level"=>"alert","message"=>'erreur commercialisation optimiz<br/> retour sql Erreur',"erreur"=>"$result[0]['erreur']['msgerreur']","email"=>$this->_session->bzUser,"@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
                                            // vide session etape prec
                                            unset($this->_session->_etapePrec);
                                            //vide time out
                                            unset($this->_session->_ctTimeOut);
                                           $stmt=$this->_db->prepare("execute ps_ExtWFormOpDel @idgrgc='$this->_idBzUser',@idwohb=$idwohb,@ip='$this->_ip'");
                                           $stmt->execute();
                                           $this->view->message="Une erreur est survenu.</br>Si le problème persiste contactez Votre agent commercial.";
                                           $this->view->error="autre";
                                          break;
                                  }
                                   
                                   $this->_helper->viewRenderer('errorsouscription');
                                   return;


                                }else{
                                    
                                    
                                    //Zend_Debug::dump($result,"sql ps_ExtWFormCtVal");
                                    $this->view->message="</br>Votre contrat a bien été enregistré.</br>Vous allez être automatiquement redirigé.</br>Merci de votre confiance.<br/>";
                                    $this->view->title="Confirmation";
                                    $this->_helper->viewRenderer('validationopti');
                                    //Zend_Debug::dump($result[0][""]);
                                    $pdfCreate=$this->pdfCreate($xmlSX=new SimpleXMLElement($result[0][""]), "", "");
                       
                                    $this->sendConfirm($this->_bzUser,"confirmation contractualisation",null,$pdfCreate,null);
                                    
                                    $this->view->numtran=$xmlSX->numtran;
                                    return;

                                }
                    //$xml=null;
                    //$this->_helper->viewRenderer('validationopti'); 
                 
                break;

            default:
                
                /**
                 * temporaire return false
                 */
                
                return false;
                //annulation ou erreur
                //vide time out
               unset($this->_session->_ctTimeOut);
               $stmt=$this->_db->prepare("execute ps_ExtWFormCtDel @idgrgc='$this->_idBzUser',@idwos=$idwos,@ip='$this->_ip'");
               $stmt->execute();
               $this->view->message="Une erreur est survenu.</br>Si le problème persiste contactez Votre agent commercial.";
               $this->view->error="autre";
                break;
        }
        
        try{
                if($xml){
                   $this->view->data=new SimpleXMLElement($xml);
                   $this->view->dataJson=Zend_Json::fromXml($xml,false); 
                } 
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
            
    }
    
    
   
    public function infosmarchesAction(){
        
        if(!$this->_acl->isAllowed($this->_role,'transaction','infosmarches')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="infosmarches";
        
         $stmt = $this->_db->prepare("execute ps_ExtWInfMarche @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                
                echo $e->getMessage();
              }
        
              if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
              }elseif($result[0][""]==""){   
                  
                  $this->view->infosMarcheData=="";
                  return;
                  
              }else{

                $xml=$result[0][""];

              }
            
       
       //Zend_Debug::dump($result,"result ps_ExtWInfMarche from sql");
            

        
            //Zend_debug::dump($xml,"info de marché");
            
            $dataXml=new SimpleXMLElement($xml);
            
            $path=$dataXml->accordion[0]->bilan[0]->documents[0]['path'];
            
            $this->_session->_docRootPath=(String)$path;
        
            $this->view->infosMarcheData=$dataXml;
            
        /**
         * log matif connexions per user
         */
        $this->_helper->Logmatifconnexions(array("level"=>"info","infos"=>$this->_idBzUser.",".$this->_ip));
        
        
    }
    
    
    public function matifAction(){
        
        if(!$this->_acl->isAllowed($this->_role,'transaction','matif')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        // get application.ini data bz
            $fc = Zend_Controller_Front::getInstance();
            $arrOptions = $fc->getParam("bootstrap")->getOptions();
            
            $bzinit=$arrOptions['bzinit'];
            $timematif=$bzinit['matiftime'];
            $this->view->callmatif=$timematif;
        //flux matif direct
           // ps_ExtWMatifRead @idgrgc INTEGER,@camp CHAR(2), @cultures varchar(500), @structures varchar(500), @param TINYINT, @ip CHAR(15)
           $stmt = $this->_db->prepare("execute ps_ExtWMatifRead @idgrgc='$this->_idBzUser',@param=1,@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
                //Zend_Debug::dump($result,"result matif");
               }catch(Zend_Exception $e){
                
                echo $e->getMessage();
              }
        
              if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
              }elseif($result[0]["XML"]==""){
                  $this->view->matifdata="";
                  exit();
              }else{
                
                $xmlMatif=$result[0]["XML"];

                $matifData=new SimpleXMLElement($xmlMatif);
                if($this->getRequest()->getParam("format")=="json"){
                    
                    
                    $this->view->data=Zend_Json::fromXml($xmlMatif,false);
                
                    
                }else{
                    
                    $this->view->matifdata=$matifData;
                    $this->view->data=Zend_Json::fromXml($xmlMatif,false); 
                }
                 
            }
        
    }
    
    
    public function analysecomAction(){
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'transaction','analysecom')){
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $this->view->action="analysecom";
        
        $stmt = $this->_db->prepare("execute ps_ExtWSyntheseView @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
        
        //Zend_Debug::dump($result[0][""],"from ps_ExtWSyntheseView");
  
        //Zend_Debug::dump($result[0][""]);
        $this->view->data=new SimpleXMLElement($result[0][""]);
        //$this->view->data=new SimpleXMLElement($xml);
        
        
    }
    
    public function analysecomculturesAction(){
        
        $this->view->action="analysescommerciales";
        $camp=$this->getRequest()->getParam("camp");
        $stmt = $this->_db->prepare("execute ps_ExtWSyntheseViewCult @idgrgc='$this->_idBzUser',@camp='$camp',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
        
        //Zend_Debug::dump($result[0][""],"from ps_ExtWSyntheseViewcult");
        
        $this->view->data=new SimpleXMLElement($result[0][""]);
        //$this->view->data=new SimpleXMLElement($xml);
        
    }
    
    public function analysecomstructuresAction(){
        
        
        $this->view->action="analysescommerciales";
        
        $camp=$this->getRequest()->getParam("camp")?$this->getRequest()->getParam("camp"):null;
         
        
        $stmt = $this->_db->prepare("execute ps_ExtWSyntheseViewStruct @idgrgc='$this->_idBzUser',@camp='$camp',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
        
        
         
        
        //Zend_Debug::dump($result[0][""],"from ps_ExtWSyntheseViewtruct");
        
        $this->view->data=new SimpleXMLElement($result[0][""]);
        //$this->view->data=new SimpleXMLElement($xml);
        
    }
    
    public function analysecomcontratsAction(){
        
        $this->view->action="analysescommerciales";
        
         $camp=$this->getRequest()->getParam("camp");
         $idti=$this->getRequest()->getParam("idti");
         $idcu=$this->getRequest()->getParam("idcu");
        

        $stmt = $this->_db->prepare("execute ps_ExtWSyntheseViewCt @idgrgc='$this->_idBzUser',@idti='$idti',@idcult='$idcu',@camp='$camp',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
              

        
//Zend_Debug::dump($result[0][""],"contrat");
      $this->view->data=new SimpleXMLElement($result[0][""]);
        //$this->view->data=new SimpleXMLElement($xml);
        //$this->view->data=new SimpleXMLElement($xml);
        //Zend_Debug::dump($this->view->data,"contrat");
        
    }
    
    public function analysecomtableauAction(){
        
        $this->view->action="analysescommerciales";
        
        $idCt=$this->getRequest()->getParam("idct")?$this->getRequest()->getParam("idct"):null;
        $stmt = $this->_db->prepare("execute ps_ExtWSyntheseViewMv @idgrgc='$this->_idBzUser',@idct='$idCt',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
  
        
        $xml=$result[0][""];
        
        $this->view->data=Zend_Json::fromXml($xml,false);
  
    }
    
    
    /**
     * handle treeview  global synthese
     */
    public function analysecomsyntheseAction(){
        
       $stmt = $this->_db->prepare("execute ps_ExtWSyntheseViewTabl @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
       
        //Zend_Debug::dump($result,"result from sql");
        //$this->view->data=Zend_Json::fromXml($xml,false);
        $this->view->data=new SimpleXMLElement($result[0][""]);
        
    }
    

    public function updatelotqteAction(){
        
                    $idLot=$this->getRequest()->getParam("idlot")?$this->getRequest()->getParam("idlot"):null;
                    $qte=$this->getRequest()->getParam("qte")?$this->getRequest()->getParam("qte"):null;
                   
                    //ps_ExtWFormLotAuto
                    //ps_ExtWFormLotQtMod     @idgrgc, @idwtrl, @qte, @ip
                    $stmt = $this->_db->prepare("execute ps_ExtWFormLotQtMod @idgrgc='$this->_idBzUser',@idwtrl=$idLot,@qte='$qte',@ip='$this->_ip'");
                       try{
                            $stmt->execute();
                            //$result=$stmt->fetchAll();
                           }catch(Zend_Exception $e){

                            //echo $e->getMessage();
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
     * contrat a affecter
     * permet d'affecter les lots aux contrats 
     */
    public function ctaffectationAction(){
        
        // ACL
        /*if(! $this->_acl->isAllowed($this->_role,'transaction','ctaffectation')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        
        $idCt=$this->getRequest()->getParam("idct");
        
        $this->view->idct=$idCt;
        
        //call ps contrats affectation ps_ExtWTCtAffect] @idgrgc INTEGER, @idct INT, @ip CHAR(15)
         $stmt = $this->_db->prepare("execute ps_ExtWTCtAffect @idgrgc='$this->_idBzUser',@idct=$idCt,@ip='$this->_ip'");
         
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                
                echo $e->getMessage();
              }
        
              if($result[0]['erreur']){
                /**
                 * @todo traitement erreur voir si la liste peux etre vide ??????
                 */
                
              }else{

                $xml=$result[0][""];

              }
              
              //Zend_Debug::dump($result,ps_ExtWTCtAffect);

            $this->view->data=new SimpleXMLElement($xml);
            
            //controle si suffisament de lots pour le contrat
            //somme des lots enable pour ce contrat
            //Zend_Debug::dump($this->view->data->lot[0]->enable,"data xml");
            $typeSomme=$this->view->data->surf?"surf":"qte";
            $qt=$this->view->data->surf?$this->view->data->surf:$this->view->data->qte;
            
            //Zend_Debug::dump($typeSomme,"typeSomme");
            
            $sommeLotEnable=0;
            
            foreach($this->view->data->lot as $lot){
                //Zend_Debug::dump($lot->enable);
                if($lot->enable==1){
                    //Zend_Debug::dump($lot,"lot");
                    $sommeLotEnable+=$typeSomme=="qte"?$lot->qte:$lot->surf;
                }
            }
            
            // comparaison pour enable disable affectation au contrat
            //Zend_Debug::dump($sommeLotEnable,"sommeLots");
            if($sommeLotEnable>=$qt){
                $this->view->valid=1;
            }else{
                $this->view->valid=0;
                $this->view->showMessage=1;
            }
             
            try{
               $this->view->data=Zend_Json::fromXml($xml,false); 
              // $this->view->formData=Zend_Json::fromXml(new SimpleXMLElement($xml),false); 
            }  catch (ErrorException $e){

                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
        
        
    }
    
    /**
     * liste des contrats a afecter
     */
    public function ctaffectationlistAction(){
         
        // ACL
        /*if(! $this->_acl->isAllowed($this->_role,'transaction','ctaffectationlist')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }*/
        //
        //call ps contrats affectation
         $stmt = $this->_db->prepare("execute ps_ExtWTCtNAffectl @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                    echo $e->getMessage();
              }
        
              //Zend_Debug::dump($result,"ps_ExtWTCtNAffectl");
              
              $xml=$result[0][""];

        
       
        //$this->view->data=new SimpleXMLElement($xml);
               
                        try{
                           $this->view->data=Zend_Json::fromXml($xml,false); 
                          // $this->view->formData=Zend_Json::fromXml(new SimpleXMLElement($xml),false); 
                        }  catch (ErrorException $e){

                            //Zend_Debug::dump($result);
                            //Zend_Debug::dump($e);
                        }
        
        
        
        
        
    }
    
    public function ctaffectvalidAction(){
        
            $lots=$this->getRequest()->getParam("checkLot");
            $idCt=$this->getRequest()->getParam("idct");
            //Zend_debug::dump($lots,"lots");
                        //itere les lots pour les concaténer dans une chaine
                        //chaine pour stock ferme
                        $strLots="";
                        //chaine pour depot
                        $strDep="";
                        if($lots && is_array($lots))
                        {    

                            foreach ($lots as $value) {
                                //Zend_debug::dump($value,"value");

                                    if($value=="") continue;
                                    $tab= explode("_",$value );
                                    //Zend_Debug::dump($tab,"tab");
                                    
                                        $strLots.=$tab[0].";".round($tab[1],3).";"; 
     
                            }
                            
                            //retire le dernier ;
                            $strLots=substr($strLots,0,-1);
                            
                        }
                        
                        //Zend_Debug::dump($strLots,"strLots");
                        
                           //ps_ExtWTCtAffectVal] @idgrgc INTEGER, @idct INT, @lotqteha VARCHAR(max), @ip CHAR(15)
                        
                           $stmt = $this->_db->prepare("execute ps_ExtWTCtAffectVal @idgrgc='$this->_idBzUser',@idct='$idCt',@lotqteha='$strLots',@ip='$this->_ip'");
                           try{
                                $stmt->execute();
                                $result=$stmt->fetchAll();
                                //Zend_Debug::dump($result,"result engagement");
                               }catch(Zend_Exception $e){
                                   /**
                                    * traitement des erreures
                                    */
                                echo $e->getMessage();
                              }
                              
                              if($result[0][erreur]==0){
                                  
                                  $this->view->data=  json_encode(array("erreur"=>0));
                                  
                              }elseif($result[0][erreur]==1){
                                  $this->view->data=  json_encode(array("erreur"=>1));
                              }elseif($result[0][erreur]==2){
                                  $this->view->data=  json_encode(array("erreur"=>2,"msg"=>$result[0][msg]));
                                  
                              }
                              
                          //Zend_Debug::dump($result,"ps_ExtWTCtAffectVal");
        
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

