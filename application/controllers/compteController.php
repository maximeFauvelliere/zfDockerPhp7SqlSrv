<?php
class compteController extends Zend_Controller_Action{
    
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
        $this->_bzUser=$this->_session->bzUser;
        $this->_ip=$this->_session->_ip;
        $this->_db=  Zend_Registry::get("db");
        $this->_acl=$this->_session->_acl;
        $this->_role=  $this->_session->_role;
        
        $ajaxContext=$this->_helper->AjaxContext;
        $ajaxContext->addActionContext('index','html')
                    ->addActionContext('changepwd','html')
                    ->addActionContext('modifystru','html')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        // ACL
        if(! $this->_acl->isAllowed($this->_role,'compte','compte')){
           
            $this->_helper->redirector('interdit','bzerror',null,array("format"=>"html"));
            $this->renderScript("/bzerror/index.tpl");
            exit();
        }
        
        /**
         * @todo plugin init var
         */
        $this->view->pageSize="5";
        $this->view->controller="push";
    }
    
    public function indexAction(){
        
        $this->view->action="index";
   
        //ps_ExtWFormCompte @idgrgc, @ip
         $stmt = $this->_db->prepare("execute ps_ExtWFormCompte @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
                   $this->_helper->LogPs("compte :ps_ExtWFormCompte @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
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
                        
                        //Zend_Debug::dump($xml,"ps_ExtWFormCompte");
        //return;
        $toto='<compte>
                    <structure>
                        <idstr>1</idstr>
                        <titre>earl</titre>
                        <nom>dewulf etienne</nom>
                        <banque>credit mutuel evreux nord</banque>
                        <siret>521563589</siret>
                        <tva>fr125488</tva>
                        <typetva>TVA</typetva>                        
                        <execution>
                            <idexec>1</idexec>
                            <nom>conche1</nom>
                            <add>chez toto</add>
                            <add2>chez tata </add2>
                            <ville>conche</ville>
                            <cp>27820</cp>
                        </execution>
                        <execution>
                            <idexec>2</idexec>
                            <nom>conche2</nom>
                            <add>chez toto</add>
                            <add2>chez tata </add2>
                            <ville>conche</ville>
                            <cp>27820</cp>
                        </execution>
                    </structure>
                    <structure>
                        <idstr>2</idstr>
                        <titre>earl2</titre>
                        <nom>dewulf etienne</nom>
                        <banque>credit mutuel evreux nord</banque>
                        <siret>521563589</siret>
                        <tva>fr125488</tva>
                        <typetva>TVA</typetva>                        
                        <execution>
                            <idexec>3</idexec>
                            <nom>conche3</nom>
                            <add>chez toto</add>
                            <add2>chez tata </add2>
                            <ville>conche</ville>
                            <cp>27820</cp>
                        </execution>
                        <execution>
                            <idexec>4</idexec>
                            <nom>conche4</nom>
                            <add>chez toto</add>
                            <add2>chez tata </add2>
                            <ville>conche</ville>
                            <cp>27820</cp>
                        </execution>
                    </structure>
              </compte>';
        
        
        
       
        
        //$execution=$this->_compte->executions;
        //$structures=$this->_compte->structures;
        //$data=new SimpleXMLElement($xml);
        
        
        $this->view->data=Zend_Json::fromXml($xml,false);
                    
        $this->view->userEmail=$this->_session->bzUser;
        //Zend_Debug::dump(Zend_Json::fromXml($execution->asXML(),false));
        //$this->view->exec=Zend_Json::fromXml($execution->asXML(),false);
        //$this->view->stru=Zend_Json::fromXml($structures->asXML(),false);
        
        
        
    }
    
    public function changepwdAction(){
        
         $stmt = $this->_db->prepare("execute ps_ExtWMailLite @login='$this->_bzUser'");
                   $this->_helper->LogPs("compte :ps_ExtWMailLite  @login='$this->_bzUser'");
                   try{
                        $stmt->execute();
                        $result=$stmt->fetchAll();
                       }catch(Zend_Exception $e){
                           /**
                            * traitement des erreures
                            */
                        echo $e->getMessage();
                      }

                        
                        //Zend_Debug::dump($result,"ps_ExtWMailLite");
        
        
        if(!$result[0]['erreur']){
            
            $result=$result[0]["url"];
            $from="commercial@beuzelin.fr";
            $to=$this->_bzUser;
            $subject=utf8_decode("Demande modification de votre mot de passe");
            $message=utf8_decode("Bonjour,<br/> Vous avez demandé la modification de votre mot de passe.\nVeuillez cliquer sur le lien ci-dessous, pour accéder a la page de modification\n").utf8_decode($result).utf8_decode("\nSi vous n'etes pas a l'origine de cette demande veuillez ne pas cliquer sur le lien et contacter un commercial.");
            
            $message='
       <p>
       Bonjour,<br/> Vous avez demandé la modification de votre mot de passe.<br/>
       Veuillez cliquer sur le lien ci-dessous, pour accéder à la page de modification.<br/>
       </p>
       
          <a href="'.utf8_decode($result).'"> '. utf8_decode($result).'</a><br/>
      
        
       <p>
           Si vous n\'êtes pas à l\'origine de cette demande veuillez ne pas cliquer sur le lien et contacter un commercial.<br/>
       </p>
       <p>
        Cordialement
       </p>
       <table>
           <tbody>
               <tr>
                   <td><img src="https://www.e-bzgrains.com/images/metier/logoBz.png" height="93px" width="71px"/></td>
                   <td style="padding-left:15px">Service commercial</br> <a href="mailto:commercial@beuzelin.fr">commercial@beuzelin.fr</a></br>02 32 67 20 60</td>
               </tr>
           </tbody>
       </table>
      ';
            
            
        }else{
            $this->view->result="Une erreur s'est produite l'email, n'a pas été envoyé.";
        }
        
         $header = "From: ".$from." <".$from.">\r\n";
         $header .= "Reply-To: ".$from."\r\n";
         $header .= "MIME-Version: 1.0\r\n";
         $header .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";
            
        if(mail($to,$subject,  utf8_decode($message),$header)){
            $this->view->result="Un email à été correctement envoyé, consultez votre messagerie, puis cliquez sur le lien.";
        }else{
            $this->view->result="Une erreur s'est produite, l'email n'a pas été envoyé.";
        }
        
    }
    
    
    public function modifystruAction(){
        
        //en tatente modification compte
        return;
        $form=$this->getRequest()->getParam("form");
        
        //call ps 
        
       
        $result=1;
        if($result){
            $this->view->result="votre structure à été correctement modifiée.";
            
        }else{
            $this->view->result="une erreur s'est produite.";
        }
        
    }
    
    
    
}
?>
