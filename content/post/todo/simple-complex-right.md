+++
author = "Michele Sciabarrà"
title = ""
date = "2020-XX-XX"
description = ""
tags = [ "Linkedin" ]
draft = true
+++


Lo schema di adozione delle nuove tecnologie si ripete sempre uguale. Ricordo di averlo letto per la prima volta nel white paper di Java: prima una nuova tecnologia utile si afferma, poi viene gonfiata aggiungendogli tutto e il contrario di tutto rendendola impossibile da usare, e infine viene ridimensionata prendendo solo ciò che serve ed eliminando la complessità inutile.

L’esempio riguardava Java. Prima c’era il C, poi evoluto nel C++ estremamente complesso, per poi venire ridimensionato a ciò che serve, appunto il linguaggio Java, un C++ semplificato con gestione memoria automatica.

Purtroppo la stessa piattaforma Java non ha evitato lo stesso destino. Si è gonfiata in maniera ipertrofica nel Java EE con i famigerati EJB, per poi venire ridimensionata dallo Spring framework che oggi è predominante.

La stessa cosa sta succedendo nel mondo dei container: prima Docker, gonfiatosi in una tecnologia super complessa come Kubernetes. OpenWhisk e il faas sono il ridimensionamento a “ciò che serve”. Un micro servizio deve essere solo una funzione, che va solo ‘messa in cloud’, i container sono un dettaglio implementativo, non vanno esplicitati.

Per ora siamo nel pieno della fase ‘vogliamo tutto’, aspettiamo pazientemente il ridimensionamento a ‘vogliamo solo ciò che serve’.