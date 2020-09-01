+++
author = "Michele Sciabarrà"
title = "You need functions not containers"
date = "2020-09-01"
description = "The right level of abstraction is the function, not the container"
tags = [ "Advocate" ]
+++


Guys, we are not there. I am talking with a lot of people those days, and I keep finding the same anxiety: "we have to move to the cloud".

You spell "cloud" and you read "distributed computing". Which means applications that are at ease in a network of servers that grows on demand. How many applications are ready for that? Obviously none.

So what companies do? On the one hand, they ask system administrators,  who promptly call themselves DevOps and get an AWS Associate certification,  the task of preparing a "distributed architecture". More or less like asking someone who has always been a butcher by profession to perform a cardio surgery.

On the other hand, ask programmers to learn containerization and orchestration to put their apps "in Kubernetes". This is roughly like asking a person who works as a building architect to get a job as a bricklayer and house painter.

Alt. Stop. Calm. Breathe. You need the RIGHT level of abstraction. And it's not that squeezed VM that is the container! It's the function! A piece of a distributed application that can be used as a  component.

You don't need Kubernetes. You need tools like OpenWhisk. And now you can rest and have peace. The awareness is not there, so It is not the time. You can go back to your YAML descriptors.