+++
author = "Michele Sciabarrà"
title = "Why Microservices?"
date = "2020-08-22"
description = "The real reason behind the OpenWhisk computational model"
tags = [ "Advocate" ]
+++


Why should you bother writing applications using micro-services? Is it really needed? What is wrong with the way they are written now? And, most importantly, how to do it? 

Web applications are,  in a way or another, collections of "services" accessible in HTTP(S). When your application runs on a single server it is easier to put everything together in one monolithic program. Most web frameworks actually are designed with this assumption in mind: one single point of control where you add your code for the services and the framework does the rest. They are monolithic.

The problem arises when you have to move your application to the cloud. The cloud is, by definition,  an "elastic" collection of servers available on demand. The cloud addresses the problem of sustaining the load when your application can be used by hundreds of thousands of people together. No matter how powerful a single server can be, it always reaches its limit and you need more servers.

Monolithic applications generally are not "elastic". The sad truth is that the overwhelming majority of the applications placed in the cloud are still monoliths and if the load increases… they can't handle it.

Cloud-native written applications are a collection of independent functions and can be deployed and duplicated in the cloud consisting of dozens of servers. They are "elastic" by construction.

OpenWhisk was designed from the ground up as a cloud-native platform for the development of micro-services. It is scalable but it is easy to use, as it has the same easiness of use of traditional development techniques.  It addresses the problem of building a cloud-native application without sacrificing easiness of use and it does it splitting your application in a collection of functions that are transformed in microservices instantly.