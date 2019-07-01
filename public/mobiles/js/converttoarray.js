/* 
 * permet de convertir les element de l'objet en tableau 
 * cela est réalisé quand un seul element enfant est dans le XML
 * Sinon template n'est pas remplis pour la ligne unique
 */

 function myConvert(obj){
                 //acc or transact etc  ....
                    var ebzObj =obj[Object.keys(obj)[0]];
                    //convert element no Array (1 elment ds le xml) en array
                    try{
                            $.each(ebzObj,function(i,e){
                                if(!Handlebars.Utils.isArray(e.element)){
                                        if(e){
                                            e.element=[e.element];
                                        }
                                }
                            })
                    }catch(error){
                            
                    }
}

function convertElementToArray(arr){
                        // convertTo array
                      if(!Handlebars.Utils.isArray(arr)){
                        if(arr){
                                            arr=[arr];
                                        }
                    }
                    
                    return arr;
}

//function myConvert special pour souscription car xml identique a e-bzgrain
function bzConvertSous(obj){
                 //acc or transact etc  ....
                 //console.log("obj",obj)
                    var ebzObj =obj[Object.keys(obj)[0]];
                    //convert element no Array (1 elment ds le xml) en array
                    ////console.log("ebzObj",ebzObj)
                    try{
                            $.each(ebzObj,function(i,e){
                                if(typeof(e)!="object" || i=="optimiz" || i=="securiz") return;
                                
                                //console.log("e",e['observations'])
                                //console.log("i",i)
                             
                                if(!Handlebars.Utils.isArray(e[0])){
                                    return;
                                        if(e){
                                            e.element=[e];
                                        }
                                }
                            })
                    }catch(error){
                            
                    }
}

