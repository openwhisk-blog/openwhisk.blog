+++
author = "Michele Sciabarrà"
title = ""
date = "2020-XX-XX"
description = ""
tags = [ "Linkedin" ]
draft = true
+++

"Quindi fammi capire come funziona, tu scrivi la funzione su github poi c'e' una pipeline..."
"No non c'è una pipeline, e non devi mettere la funzione su github, la mandi direttamente e viene "deployata" per l'esecuzione."
"Che significa la mandi direttamente in esecuzione? Non devi costruire un container prima?"
"Il container c'è, accetta una funzione e la esegue..."
"Non c'è Jenkins?"
"No."
"E non buildi le immagini Docker?"
"Sono già pronte. Ci sono delle immagini runtime per eseguire node, python, java, go, rust..."
"E la tua funzione cosa deve fare? Far partire un server http..."
"No la tua funzione deve prendere un input e ritornare un output. L'input è un json e l'output è un json."
"E come la testi?"
"La deploy e la puoi eseguire. Ma fai meglio scrivere unit test. Sono solo funzioni quindi è facile."
"E come la debugghi?"
"C`è un debugger per eseguirle passo passo. Ma io insisto che fai meglio a scrivere unit test."
"Ed è cloud-native?"
"Si, vengono eseguite su nodi multipli, distribuite da kafka, in autoscaling, con un load balancer."
"Mi chiedo perchè Nimbella mi sembra troppo semplice."
"Dovresti chiederti invece perchè il cloud-native lo fanno così complicato."