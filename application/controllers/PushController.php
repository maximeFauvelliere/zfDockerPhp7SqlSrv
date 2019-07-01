<?php
class PushController extends Zend_Controller_Action
{
    
     // idgrgc
    private $_idBzUser;
    // identifiant 
    private $_bzUser;
    private $_session;
    private $_ip;
    private $_db;
    private $_acl;
    private $_role;
    /**
     *
     * @var json
     */
    private $_notifications;
    /**
     *
     * @var simpleXMl 
     */
    private $_notificationXML;
    
    //upload 
    private $_tempFileName;
    private $_fileName;
    
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
        $ajaxContext->addActionContext('index','json')
                    ->addActionContext('messages','html')
                    ->addActionContext('messageread','html')
                    ->addActionContext('messagedelete','json')
                    ->addActionContext('sendmail','json')
                    ->setAutoJsonSerialization(false)
                    ->initContext();
        
        /**
         * @todo  faire plugin config
         */
        $this->view->pageSize=5;
        
        
        /**
         *get all notification (libellé) by rubriques:
         * messagerie,taches,document
         * return objet json 
         */
         //get notifications contents
        
        $stmt = $this->_db->prepare("execute ps_ExtWNotifyView @idgrgc='$this->_idBzUser',@ip='$this->_ip'");
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                /**
                 * gestion erreur
                 */   
                //echo $e->getMessage();
              }
       
              
              //Zend_Debug::dump($result,"result view");
              
              if(!isset($result)) return;
              
              $this->_notificationXML=$result[0][""];

               try{
                if(!$this->_notificationXML!=null){
                    $this->_notificationXML='<notifications><notification></notification></notifications>';
                }
            }  catch (ErrorException $e){
               /**
                * @todo gere les erreurs
                */
                //Zend_Debug::dump($result);
                //Zend_Debug::dump($e);
               
            }
        
           
            //Zend_Debug::dump($this->_notificationXML,"notifications");

        
    }
    
   
    public function indexAction(){

       $notifications=$this->_helper->Push();
        
       if($notifications){
            
           $this->_notifications=json_encode($notifications); 
       }else{
           $this->view->result="undefined";
       }
       
       //Zend_Debug::dump($notifications,"notifications");
       $this->view->result=  $this->_notifications;
    }
    
    /**
     *return le content de la messagerie 
     */
    public function messagesAction(){

        //liste desrtinataire mail
         $stmt = $this->_db->prepare("execute ps_ExtWNotifyGetDest @idgrgc='$this->_idBzUser',@ip='$this->_ip'");

           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
        
                $result=null;
              }
        //Zend_Debug::dump($result,"ps_ExtWNotifyGetDest");
        
        $this->view->destinataires=$result;
        
        //cast
        $xml=new SimpleXMLElement($this->_notificationXML);
        
        $this->_session->_docRootPath=(String)$xml->path;

        unset($xml->path);
       
        //Zend_Debug::dump($this->_session->_docRootPath,"path");
        
        $bzSelectDoc=array();
              foreach ($xml->notification->message as $doc) {
                  
                  //Zend_Debug::dump($doc['label'],"doc");
                  // jump les doublons
                  if (array_key_exists((string)$doc['type'], $bzSelectDoc)) continue;
                  
                  $bzSelectDoc[(string)$doc['type']]=$doc['label'];
                  
              }

        
       
             //Zend_Debug::dump($this->_notificationXML,"notificationXML");
       
        $this->view->selectList=$bzSelectDoc;

        //Zend_Debug::dump(Zend_Json::fromXml($messages->asXML(),false),"jsonfromxml");
        if(true){
            $this->view->result=Zend_Json::fromXml($xml->asXML(),false);
        }else{
            $this->view->result="undefined";
        }
    }
    
    /**
     *@return message content 
     */
    public function messagereadAction(){
        //get param from request
        $idMessage=$this->getRequest()->getParam("idMessage");
        // call PS for message content
       
        $id=$this->getRequest()->getParam("idMessage");
        // cette ps ne renvois rien , met juste a jour la db
        $stmt = $this->_db->prepare("execute ps_ExtWNotifyRead @idgrgc='$this->_idBzUser',@idwnd='$id',@ip='$this->_ip'");
           
           try{
                $stmt->execute();
               }catch(Zend_Exception $e){
                   
              }
       
    }
    /**
     *delete message 
     * @return bool
     * @param idMessage 
     */
    public function messagedeleteAction(){
        //get param from request
        $idMessage=$this->getRequest()->getParam("idMessage");
        // call ps delete
        $stmt = $this->_db->prepare("execute ps_ExtWNotifydel @idgrgc='$this->_idBzUser',@idwnd='$idMessage',@ip='$this->_ip'");
        $this->_helper->LogPs("pushController :ps_ExtWNotifydel @idgrgc,@idwnd,@ip");
           
           try{
                $stmt->execute();
                $result=$stmt->fetchAll();
               }catch(Zend_Exception $e){
                   
              }
        
        $this->view->result=1;
        
        
    }

    public function sendmailAction(){
        
        //send mail info to db
        $a=$this->getRequest()->getParam("a");
        $txt=  $this->getRequest()->getParam("txt");
        $subject= $this->getRequest()->getParam("subject");
        
        $stmt = $this->_db->prepare("execute ps_ExtWNotifyGetMail @idgrgc='$this->_idBzUser',@subject='$subject',@dest='$a',@content='$txt',@ip='$this->_ip'"); 
           try{
                $stmt->execute();
               }catch(Zend_Exception $e){
                   
              }
        
        //data decode to mail
        $message=  urldecode($this->getRequest()->getParam("txt"));
        $to=  urldecode($this->getRequest()->getParam("a"));
        $from=$this->_bzUser;

        $subject= utf8_encode(urldecode($this->getRequest()->getParam("subject")));

            
            $uid = md5(uniqid(time()));
            
            $header = "From: ".$from." <".$to.">\r\n";
            $header .= "Reply-To: ".$to."\r\n";
            $header .= "MIME-Version: 1.0\r\n";
            
            // gestion piece joint uniquement si un fichier a était uploadé
            if($this->_session->_uploadPjUrl){
            //create a boundary string. It must be unique 
            $filename=$this->_session->_uploadFileName;
            $file = $this->_session->_uploadPjUrl;
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
                echo json_encode('{"error":0,"msg":"Votre email a été envoyé avec succés"}');
                
                
                if(file_exists($this->_session->_uploadPjUrl))  unlink($this->_session->_uploadPjUrl);
                unset($this->_session->_uploadPjUrl);
                unset($this->_session->_uploadFileName);
            } else {
                
                echo json_encode('{"error":1,"msg":"Une erreur c\'est produite, veuillez éssayer à nouveau."}');
            }

    }
    
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
             return;
        }
        
        $dossier = "./../pjprod/";
        
        if(move_uploaded_file($_FILES['bzUpload']['tmp_name'], $dossier . basename($_FILES['bzUpload']['name']))) 
        {
              $this->_session->_uploadPjUrl= realpath($dossier . basename($_FILES['bzUpload']['name']));
              $this->_session->_uploadFileName= basename($_FILES['bzUpload']['name']);
             
        }else{
              echo 'Echec de l\'envois de votre piece jointe';
              return;
        }

    }
    
}
?>
