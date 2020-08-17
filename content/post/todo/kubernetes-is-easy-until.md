+++
draft = "true"
+++

Kubernetes é facile fino a che:  
  
"Un nodo che muore e perdono tutti i dati perché non sapevano che i dati nel container erano effimeri.”  
  
“Pod che vanno in crash loop e non si ha idea perché visto che in locale funzionano.”  
  
“Problemi di rete per conflitti di indirizzi interni con la rete esterna e nessuno aveva idea che ci fosse una rete interna.”  
  
“Sistema rallentato perché ad un crash di un pod Kubernetes decide di rischedulare un pod critico in un altro nodo.”  
  
“Pod critici che rimangono pending perché qualcuno ha deployato un pod più volte consumando tutta la cpu disponibile"  
  
Ora, non é che queste cose non succedano. Ma se volete che queste cose succedano A NOI invece che a VOI, abbiamo creato Nimbella.  
  

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTE0NjY4MDExODZdfQ==
-->