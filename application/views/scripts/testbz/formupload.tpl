<form method="POST" action="/testbz/pjupload/" enctype="multipart/form-data">
     <!-- On limite le fichier à 100 000Ko -->
     <input type="hidden" name="MAX_FILE_SIZE" value="100000000">
     Fichier : <input type="file" name="fileUpload">
     <input type="submit" name="envoyer" value="Envoyer le fichier">
</form>
