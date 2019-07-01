<?php

class ProspectionController extends Zend_Controller_Action
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
    
    private $_msgErrorSuff1;
    
    
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

        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('depot','html')
                    ->addActionContext('ferme','html')
                    ->addActionContext('addferme','html')
                    ->addActionContext('accueil','html')
                    ->addActionContext('showlot','html')
                    ->addActionContext('dellot','json')
                    ->addActionContext('createanalyse','json')
                    ->addActionContext('supanalyse','json')
                    ->addActionContext('modifyanalyse','json')
                    ->addActionContext('validateferme','json')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        // ACL
        if( !$this->_acl->isAllowed($this->_role,'prospection','init')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
           
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
       
        $fc = Zend_Controller_Front::getInstance();
        $arrOptions = $fc->getParam("bootstrap")->getOptions();
        $bzinit=$arrOptions['bzinit'];
        
        $this->_msgErrorSuff1=$bzinit['msg_error_suffix1'];
        $this->view->pageSize=$bzinit['page_size'];
        $this->view->controller="prospection";
        
        
    }
    
    public function indexAction(){
 
        $stmt = $this->_db->prepare("execute ps_ExtWAcc @idgrgc='$this->_idBzUser',@code='PRO',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
                 //Zend_Debug::dump($result,"result from sql");
                
               }catch(Zend_Exception $e){
        
              }
        
           
            //Zend_Debug::dump($result,"result from sql");
           
           /**
             * traitement erreur retour sql
             * placer ici pour eviter d'avoir a reconstruire le tableau 
             * pour $this->data
             */
            if($result[0]['erreur']){
                
                $this->_forward('notice','bzerror',null,array("format"=>"html","erreur_sql"=>$result[0]['erreur'],"ps"=>"ps_ExtWAcc","@idgrgc"=>$this->_idBzUser,"@code"=>'PRO',"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                
                $this->_data='<cellules>
                                <cellule titre="Stock Dépot" img=""></cellule>
                                <cellule titre="Stock Ferme" img=""></cellule>
                             </cellules>';
            }else{
               
                $this->_data=$result[0][""];
            }
            
            //Zend_Debug::dump($this->_data,"data brutes");
            
            try{
               $this->view->data=Zend_Json::fromXml($this->_data,false); 
            }  catch (ErrorException $e){
               
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
            }
           
           
            /**
             * analyses en atentes 
             */
           if(true){
               
               $this->view->btAnalyse=true;
           }
           
           $stmt = $this->_db->prepare("execute ps_ExtWAnalysesNotify @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
           $this->_helper->LogPs("prospectionController :ps_ExtWAnalysesNotify @idgrgc,@camp,@cultures',@structures',@param,@ip");
           
           try{
                $stmt->execute();
                $nbAnalyses=$stmt->fetchAll();
               
               }catch(Zend_Exception $e){
     
                $this->_forward('notice','bzerror',null,array("message"=>'Une erreur s\'est produite code:PR_index_2<br/>'.$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWAnalysesNotify","@idgrgc"=>$this->_idBzUser,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
              
                return;
              }
        
              //Zend_Debug::dump($result[0]['compte']);
              
             if(!$nbAnalyses[0]['compte']){
            /**
             * @todo gestion erreur
             */
                 $nbAna=0;
            }else{
                
                /**
                 * @todo gestion erreur retour sql
                 */
                
                $nbAna=$nbAnalyses[0]['compte'];

            }

           $this->view->nbAnal=$nbAna;

        //redirige vers prospection accueil
        $this->renderScript("/prospection/accueil.ajax.tpl");
    }
    
    

    public function depotAction()
    {
       
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','depot')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            
            exit();
        }
        
        $this->view->action="depot";
           //data globale
        $this->_gData=$this->_helper->Getglobal($this->_db,"PRO",$this->_filter);
        
        $this->view->siloData=$this->_gData;
        
        //data detail lot
        $stmt = $this->_db->prepare("execute ps_ExtWPSDepot @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
           
           try{
               
                $stmt->execute();
                $result=$stmt->fetchAll();
                
               }catch(Zend_Exception $e){
        
                
                $this->_forward('notice','bzerror',null,array("message"=>'Une erreur s\'est produite code:PR_index_3<br/>'.$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWPSDepot","@idgrgc"=>$this->_idBzUser,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                return;
              }
        
           
            if(!$result[0][""]){
              
                //$this->_forward('notice','bzerror',null,array("message"=>'Une erreur s\'est produite code:PR_index_3<br/>'.$this->_msgErrorSuff1,"format"=>"html","resultXml"=>"invalide ou nul","ps"=>"ps_ExtWPSDepot","@idgrgc"=>$this->_idBzUser,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                //return;
            }

            if(count($result)){
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
            
            //Zend_Debug::dump($result[0][""]);
            
            try{
                
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index");
            }
            
          
       
    }
    
    /**
     *detail du stock ferme
     * charge l'ensemble des cellule pour le stock ferme 
     */
    public function fermeAction()
    {
        $this->view->action="ferme";
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','ferme')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        //data globale
        $this->_gData=$this->_helper->Getglobal($this->_db,"PRO",$this->_filter);
        
        //Zend_Debug::dump($this->_gData,"gData xml");
        
        $this->view->siloData=$this->_gData;
        
        //data detail lot
        $stmt = $this->_db->prepare("execute ps_ExtWPSFLotsV2 @idgrgc='$this->_idBzUser',@camp=$this->_camp,@cultures='$this->_cultures',@structures='$this->_structures',@param=$this->_param,@ip='$this->_ip'");
        
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
                //throw new Zend_Exception("test");
               }catch(Zend_Exception $e){

                $this->_forward('notice','bzerror',null,array("message"=>'Une erreur s\'est produite code:PR_index_4<br/>'.$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWPSFLots","@idgrgc"=>$this->_idBzUser,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                return;
              }
        
           
            //Zend_Debug::dump($result,"ps_ExtWPSFLotsV2");
            if(!$result[0][""]){
                 //$this->_helper->flashMessenger->addMessage('Une erreur s\'est produite code:PR_index_5<br/>'.$this->_msgErrorSuff1,'error'); 
                //$this->_helper->redirector->gotoUrl('/bzerror/notice/format/html');
                //$this->_forward('notice','bzerror',null,array("message"=>'Une erreur s\'est produite code:PR_index_5<br/>'.$this->_msgErrorSuff1,"format"=>"html","resultXml"=>"invalide ou nul","ps"=>"ps_ExtWPSFLots","@idgrgc"=>$this->_idBzUser,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                //return;
            }
            
            if(count($result)){
                $this->_data=$result[0][""];
            }else{
                $this->_data=null;
            }
            
            try{
                
                $this->view->data=Zend_Json::fromXml($this->_data,false);
                
            }catch(Zend_Exception $e){
                // plus ou pas  de stock ferme on renvois sur l'index
                $this->_forward("index");
            }
 
    }        
    /**
     *show formulaire pour ajout lot (stock ferme, une cellule)
     */
    public function addfermeAction(){
        
            // ACL
            if(! $this->_acl->isAllowed($this->_role,'prospection','addferme')){

                $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
                $this->renderScript("/bzerror/index.tpl");
                exit();
            }
 
           // si aucun param => requete iniale call ps
          
                $stmt = $this->_db->prepare("execute ps_ExtWFormLot @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
                
                try {
                        $stmt->execute();
                        $resultXml=$stmt->fetchAll();
                        
                        } catch (Exception $exc) {
                           
                            $this->_forward('notice','bzerror',null,array("message"=>'Une erreur s\'est produite code:PR_index_6<br/>'.$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWFormLot","@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
                            return;
                        }

                        $xml=$resultXml[0][""];
                        
                        $this->view->formData=Zend_Json::fromXml($xml,false);

                        //si le Xml est null
                        /**
                         *@todo voir le cas du xml null voir si afcher bt addlot 
                         */
                        if(!$xml){
                              
                                $this->_forward('notice','bzerror',null,array("message"=>"'Une erreur s\'est produite code:PR_index_7<br/>'.$this->_msgErrorSuff1","format"=>"html","resultXml"=>"invalide ou nul","ps"=>"ps_ExtWFormLot","@idgrgc"=>$this->_idBzUser,"@ip"=>$this->_ip));
               
                                $this->_helper->redirector('index','administration');
                                exit();
                            }
                            //Zend_Debug::dump($xml);
                            $xml=new SimpleXMLElement($xml);
                           
            $this->view->formLotXml=$xml;

        
    }
    
    /**
     *send and valid 
     * le formulaire de creation de lot(ferme cellule)
     */
    public function validatefermeAction(){
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','validateferme')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        //Zend_Debug::Dump($this->getRequest()->getParam("cult"));
        
        
        //check if is update or create
        $isModification=$this->getRequest()->getParam("update");

        $isModification= isset($isModification)&&$isModification==1?true:false;
        
        $lib=$this->getRequest()->getParam("lib")?$this->getRequest()->getParam("lib"):null;
        $clecu=$this->getRequest()->getParam("cult")?$this->getRequest()->getParam("cult"):null;
        $idwdst=$this->getRequest()->getParam("dest")?$this->getRequest()->getParam("dest"):null;
        $ha=$this->getRequest()->getParam("surface")?$this->getRequest()->getParam("surface"):0;
        $estimrend=$this->getRequest()->getParam("rendement")?$this->getRequest()->getParam("rendement"):0;
        $qte=$this->getRequest()->getParam("poid")?$this->getRequest()->getParam("poid"):0;
        $exe=$this->getRequest()->getParam("exe")?$this->getRequest()->getParam("exe"):null;
        $struct=$this->getRequest()->getParam("struct")?$this->getRequest()->getParam("struct"):null;
        $criteres=$this->getRequest()->getParam("criteres")?$this->getRequest()->getParam("criteres"):null;
        $idwtrl=$this->getRequest()->getParam("idLot")?$this->getRequest()->getParam("idLot"):null;
        $type=$this->getRequest()->getParam("typeList")?$this->getRequest()->getParam("typeList"):null;
        //itere les criteres pour les concaténer dans une chaine
        $strCriteres="";
        if($criteres && is_array($criteres))
        {    
            foreach ($criteres as $value) {
                foreach ($value as $k => $v) {
                    if($v=="") continue;
                    $strCriteres.=$k.";".$v.";"; 
                }
            }
            
            //retire le dernier ;
            $strCriteres=substr($strCriteres,0,-1);
        }
        
       
        //valide les data du formulaires dans leur type
        $lib= addslashes($lib);
        $clecu= is_numeric((int)$clecu)?$clecu:0;
        $idwdst= is_numeric((int)$idwdst)?$idwdst:0;
        $ha= is_numeric((int)$ha)?str_replace(",", ".", $ha):0;
        $qte=  is_numeric((int)$qte)?str_replace(",", ".", $qte):0;
        $estimrend=  is_numeric((int)$estimrend)?str_replace(",", ".", $estimrend):0;
        $exe= is_numeric((int)$exe)?$exe:0;
        $struct= is_numeric((int)$struct)?$struct:0;
        

        /**
         *@todo voir si modification joue encore , je ne crois pas  
         */
        if(!$isModification){
                //create
                
                try {
                        $stmt = $this->_db->prepare("execute ps_ExtWFormLotAdd @idgrgc='$this->_idBzUser',@idwtrl='0',@lib='$lib',@qte=$qte,@idcty='$type',@ha='$ha',@estimrend='$estimrend',@clecu='$clecu',@idwdst='$idwdst',@idexe='$exe',@idti='$struct',@criteres='$strCriteres',@ip='$this->_ip'");
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                        //throw new Zend_Exception("test");
                        

                    } catch (Exception $exc) {

                        $this->_forward('notice','bzerror',null,array("message"=>'Erreur : Votre lot n\'a peut pas été modifié code:PR_index_8<br/>'.$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWFormLotAdd","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>'0',"@lib"=>$lib,"@qte"=>$qte,"@idcty"=>$type,"@ha"=>$ha,"@estimrend"=>$estimrend,"@clecu"=>$clecu,"@idwdst"=>$idwdst,"@idexe"=>$exe,"@idti"=>$struct,"@criteres"=>$strCriteres,"@ip"=>$this->_ip));
                        return;
                    }

                }else{
                    //update
                    
                    try {
                            $stmt = $this->_db->prepare("execute ps_ExtWFormLotAdd @idgrgc='$this->_idBzUser',@idwtrl='$idwtrl',@lib='$lib',@qte=$qte,@idcty='$type',@ha='$ha',@estimrend='$estimrend',@clecu='$clecu',@idwdst='$idwdst',@idexe='$exe',@idti='$struct',@criteres='$strCriteres',@ip='$this->_ip'");
                            $stmt->execute();
                            $result=$stmt->fetchAll();
                            
                        } catch (Exception $exc) {
                            $this->_forward('notice','bzerror',null,array("message"=>'Erreur : Votre lot n\'a peut pas été modifié code:PR_index_9<br/>'.$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWFormLotAdd","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@lib"=>$lib,"@qte"=>$qte,"@idcty"=>$type,"@ha"=>$ha,"@estimrend"=>$estimrend,"@clecu"=>$clecu,"@idwdst"=>$idwdst,"@idexe"=>$exe,"@idti"=>$struct,"@criteres"=>$strCriteres,"@ip"=>$this->_ip));
                            return;
                        }
        }  
            
        if($result){
            $this->view->result= json_encode($result[0]['erreur']);
        }
            
                       
           
    }
    
    /**
     *affichage formulaire pré-remplis pour modification 
     */
    public function showlotAction(){
        
            // ACL
            if(! $this->_acl->isAllowed($this->_role,'prospection','showlot')){

                $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
                $this->renderScript("/bzerror/index.tpl");
                exit();
            }
        //parametres dans la requete

           $idwtrl=$this->getRequest()->getParam('id')?$this->getRequest()->getParam('id'):null;
           
            $this->view->idLot=$idwtrl;
          
                $stmt = $this->_db->prepare("execute ps_ExtWPSFLot @idgrgc='$this->_idBzUser',@idwtrl='$idwtrl',@ip='$this->_ip'");
                try {
                        $stmt->execute();
                        $resultXml=$stmt->fetchAll();


                        } catch (Exception $exc) {
                            $this->_forward('notice','bzerror',null,array("message"=>'Erreur : Votre lot n\'a peut pas été modifié code:PR_index_10<br/>'.$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWPSFLot","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@ip"=>$this->_ip));
                            return;
                        }

                        $xml=$resultXml[0][""];
                        //Zend_Debug::dump($xml,"showLot data");  
                        $this->view->formData=Zend_Json::fromXml($xml,false);

                        //si le Xml est null
                        /**
                         *@todo voir le cas du xml null voir si afcher bt addlot 
                         */
                        if(!$xml){
                                $this->_forward('notice','bzerror',null,array("message"=>'Une erreur est survenue code:PR_index_11<br/>'.$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWPSFLot","resultXml"=>"nul ou invalide","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@ip"=>$this->_ip));
                                return;
                            }

                            $xml=new SimpleXMLElement($xml);
                         

            $this->view->formLotXml=$xml;
            

        
        
    }
    
    /**
     *supression d'un lot 
     */
    public function dellotAction(){
        
        
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','dellot')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $idwtrl=$this->getRequest()->getParam("idLot");

         $stmt = $this->_db->prepare("execute ps_ExtWFormLotDel @idgrgc='$this->_idBzUser',@idwtrl='$idwtrl',@camp='$this->_camp',@cultures='$this->_cultures',@structures='$this->_structures',@param='$this->_param',@ip='$this->_ip'");
         try {
                $stmt->execute();
                $result=$stmt->fetchAll();

                if(!$result[0]['erreur']==0){

                    $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_12<br/>".$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWFormLotDel","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                    return;
                    
                }else{
                    
                    $this->_forward('ferme', null, null, array('format'=>'html'));
                    return;
                    $xml=$result[0][""];
                    
                    //voir ce qu'il faut retourné pour null , peut etre pas utile si redirection ajax direct
                    if(!$xml){$this->view->result="data null";return;}
                    
                    $this->view->result=Zend_Json::fromXml($xml,false);
                    
                   return;                   
                }

            } catch (Exception $exc) {
                //echo $exc->getTraceAsString();
                $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_13<br/>".$this->_msgErrorSuff1,"format"=>"html","ps"=>"ps_ExtWFormLotDel","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@camp"=>$this->_camp,"@cultures"=>$this->_cultures,"@structures"=>$this->_structures,"@param"=>$this->_param,"@ip"=>$this->_ip));
                return;
            }
        
        
    }
    
    /**
     * ajoute une analyse au lot selectionné
     * @return XML 
     */
    public function createanalyseAction(){
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','createanalyse')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $criteres=$this->getRequest()->getParam("criteres")?$this->getRequest()->getParam("criteres"):null;
        $lib=$this->getRequest()->getParam("lib")?$this->getRequest()->getParam("lib"):null;
        $idwtrl=$this->getRequest()->getParam("id")?$this->getRequest()->getParam("id"):null;

        //itere les criteres pour les concaténer dans une chaine
        $strCriteres="";
        
        foreach ($criteres as $k => $v) {
                if($v=="") continue;
                $strCriteres.=$k.";".$v.";"; 
        }

        
        //retire le dernier ;
         $strCriteres=substr($strCriteres,0,-1);
         
         //valide les data du formulaires dans leur type
         $lib= addslashes($lib);
         
         $stmt = $this->_db->prepare("execute ps_ExtWAnalyseAdd @idgrgc='$this->_idBzUser',@idwtrl='$idwtrl',@criteres='$strCriteres',@lib='$lib',@ip='$this->_ip'");
         $this->_helper->LogPs("prospectionController :ps_ExtWAnalyseAdd @idgrgc,@idwtrl,@criteres,@lib,@ip");
         try {
                $stmt->execute();
                $result=$stmt->fetchAll();
                //tritement des erreurs
                if(!$result[0]['erreur']==0){
                    $this->view->result=$result[0]['erreur'];
                    $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_14<br/>".$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWAnalyseAdd","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@idwtrl"=>$idwtrl,"@criteres"=>$strCriteres,"@lib"=>$lib,"@ip"=>$this->_ip));
                    return;
                }else{
                    
                    $xml=$result[0][""];
                
                $this->view->result=Zend_Json::fromXml($xml,false);

                //Zend_Debug::dump($result);
                
                return;
                    
                }

            } catch (Exception $exc) {
                //echo $exc->getTraceAsString();
                $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_15<br/>".$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWAnalyseAdd","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idwtrl,"@idwtrl"=>$idwtrl,"@criteres"=>$strCriteres,"@lib"=>$lib,"@ip"=>$this->_ip));
                    return;
            }

    }
    
    /**
     * delete analyse from selected lot
     * @return XML
     */
    function supanalyseAction(){
        
         // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','supanalyse')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $idAna=$this->getRequest()->getParam("idAna")?$this->getRequest()->getParam("idAna"):null;
        $idLot=$this->getRequest()->getParam("idLot")?$this->getRequest()->getParam("idLot"):null;
        
        
        $stmt = $this->_db->prepare("execute ps_ExtWAnalyseDel @idgrgc='$this->_idBzUser',@idwtrl='$idLot',@idgra='$idAna',@ip='$this->_ip'");
        try {
                $stmt->execute();
                $result=$stmt->fetchAll();
                //traitement des erreurs
                if(!$result[0]['erreur']==0){
                    $this->view->result=$result[0]['erreur'];
                    $this->_helper->redirector('notice','bzerror',null,array("format"=>"json","message"=>"Une erreur est survenue. Votre analyse n'a peut être pas été supprimée."));
                    
                    exit();
                    
                }else{
                    
                    $xml=$result[0][""];
                
                $this->view->result=Zend_Json::fromXml($xml,false);

                //Zend_Debug::dump($result);
                
                return;
                    
                }
                
                
                 

            } catch (Exception $exc) {
                //echo $exc->getTraceAsString();
                $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_17<br/>".$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWAnalyseDel","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idLot,"@idgra"=>$idAna,"@ip"=>$this->_ip));
                return;
            }

        
        
        
    }
    
    /**
     * modifie une ou plusieurs analyses
     * les valid et les envois
     * @return xml 
     */
    function modifyanalyseAction(){
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'prospection','modifyanalyse')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        $checked=$this->getRequest()->getParam("checked")?1:0;
        $criteres=$this->getRequest()->getParam("criteres")?$this->getRequest()->getParam("criteres"):null;
        $idLot=$this->getRequest()->getParam("idLot")?$this->getRequest()->getParam("idLot"):null;
        $idAna=$this->getRequest()->getParam("idAna")?$this->getRequest()->getParam("idAna"):null;
   
        //itere les criteres pour les concaténer dans une chaine
        $strCriteres="";
       
        if(isset($criteres)){

                foreach ($criteres as $k => $v) {
                    
                    if($v==""){
                       
                        $strCriteres.=$k.";null;"; 
                        continue;
                    }

                    $strCriteres.=$k.";".$v.";"; 
                }
            //}
            //retire le dernier ;
            $strCriteres=substr($strCriteres,0,-1);
            
        } 
        

         try {
             $stmt = $this->_db->prepare("execute ps_ExtWAnalyseMod @idgrgc='$this->_idBzUser',@idwtrl='$idLot',@idgra='$idAna',@checked='$checked',@criteres='$strCriteres',@ip='$this->_ip'");
             $stmt->execute();
                $result=$stmt->fetchAll();
                //traitement des erreurs
                if(!$result[0]['erreur']==0){
                    $this->view->result=$result[0]['erreur'];
                    $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_18<br/>".$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWAnalyseMod","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idLot,"@idgra"=>$idAna,"@checked"=>$checked,"@criteres"=>$strCriteres,"@ip"=>$this->_ip));
                    return;
                }else{
                    
                    $xml=$result[0][""];
                
                    $this->view->result=Zend_Json::fromXml($xml,false);
                    return;
                    
                }

            } catch (Exception $exc) {
                //echo $exc->getTraceAsString();
                $this->_forward('notice','bzerror',null,array("message"=>"Une erreur est survenue.  code:PR_index_19<br/>".$this->_msgErrorSuff1,"format"=>"json","ps"=>"ps_ExtWAnalyseMod","@idgrgc"=>$this->_idBzUser,"@idwtrl"=>$idLot,"@idgra"=>$idAna,"@checked"=>$checked,"@criteres"=>$strCriteres,"@ip"=>$this->_ip));
                return;
            }

    }
  
}

