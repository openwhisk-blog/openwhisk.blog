+++
author = "Michele Sciabarrà"
title = "Apache OpenWhisk is a truly multi-cloud Serverless Platform"
description = "OpenWhisk is a truly portable and multiplatform Serverless engine and it is available now on all the major clouds from multiple commercial vendors."
date = "2020-09-18"
tags = [ "Advocate" ]
hidden = true
+++

<iframe width="560" height="315" src="https://www.youtube.com/embed/02Xezhf_j4U" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

{{< youtube 02Xezhf_j4U  >}}

Apache OpenWhisk is a Serverless Cloud Platform, developed as an open source project at the Apache Software Foundations.  It is similar to Amazon Lambda, Google Functions or Azure Functions. The main difference is that it is an Open Source project and that is offered by multiple commercial vendors.

Many vendors today offer cloud functions based on OpenWhisk, and it runs on all the major public clouds. However not all the vendors disclose where they run their services, so I will refer to the vendor and not to the cloud that runs it. It can also be installed on any Kubernetes cluster, so you can install in any cloud, either your private cloud or the public one you prefer.

In this article I am going to show that OpenWhisk is a truly portable serverless solution, and that you can write a serverless application and then run it on multiple vendors.

To prove my point, I wrote an open source serverless application and run it on all the OpenWhisk vendors I got access to. I also created a custom Kubernetes cluster, installed OpenWhisk in it to run my application.

 The application is a chess engine, written in the Go programmaing language, that includes backend and frontend; using it you can to play chess using a web interface, while the opponent is an artificial intelligence running as a serveless function in OpenWhisk.


# Local Deploy

For testing and development you can use the Standalone OpenWhisk. It is a single node installation that can run in your machine and only requires [`docker`](https://docker.com) to run. You also need to download the [OpenWhisk cli tool `wsk`](https://github.com/apache/openwhisk-cli/releases/tag/1.0.0) for your operating system in order to interact with OpenWhisk.

Once prerequisites are satisfied, you can start a local OpenWhisk with the following command:

```
bash <(curl -sL https://s.apache.org/openwhisk.sh)
```

The command will download a docker image for standalone OpenWhisk and it will start it. It will also open the playground, that you can use to create and run a function on the fly.

![Playground](playground-ui.png)

Once you have OpenWhisk up and running you can configure the `wsk` tool to access it.  OpenWhisk access is protected by a key that you have to retrieve and use to configure `wsk`, as follows:

```
AUTH=$(docker exec openwhisk wsk property get --auth | awk '{ print $3}')
wsk property set --auth $AUTH --apihost http://localhost:3233
````

# Building and testing our Chess Action

Now  let's build our chess engine and use the local OpenWhisk  to test it locally. Source code of the chess engine [is available on GitHub](https://github.com/openwhisk-blog/whisk-chess).

Code is based on a freely available chess engine written in Go, [CounterGo](https://github.com/ChizhovVadim/CounterGo/pulls). I adapted it to run as a stateless serveless action, and I added a front-end in javascript,  using the libraries [Chessboardjs](https://chessboardjs.com) and [chess.js](https://github.com/jhlywa/chess.js).

In order to build the action, you need common tools like `git`, `make` and `docker`. Once you got them you can download and build the sources with the commands:

```
git clone https://github.com/openwhisk-blog/whisk-chess
cd whisk-chess
make
```

Note that you do not need a Go compiler to build the action, just Docker, as you can compile the action using the runtime itself. The result is the file `chess.zip` containg a precompiled Go action ready to be deployed.


Once you have the action, you use the following command to deploy it in OpenWhisk:

```
wsk action update chess chess.zip --kind go:1.11 --web true
```

Finally you can retrieve the URL of the action with the command:

```
wsk action get chess --url
```

If you now type the URL in a browser you will see the user interface of our chess engine,  a chessboard, and you can play chess against the computer.

![Chess](chess.png)

# Nimbella

Now let's start deploying  our chess in the services of the various vendors that offer OpenWhisk. 

[Nimbella](https://nimbella.com) offers a serverless solution based on OpenWhisk that focus on providing an "awesome developer experience". 

I think it is  appropriate to say that I work for Nimbella, but I am trying to be neutral in this article and offer  a fair comparison of all the OpenWhisk vendors I am aware of.

![Nimbella](020.png)

Nimbella uses its own tool for deployment, [`nim`, that was recently opensourced](https://github.com/nimbella/nimbella-cli/). You need to register to their service and you will receive an authentication token that you can use to login in it. Once you are logged in, you can deploy our chess action and get an URL for it. 

```
nim auth login "$NIMTOKEN"
nim action update chess chess.zip --kind go:1.12 --web true
nim action get chess --url
```

[Follow this link to play chess on Nimbella](https://apigcp.nimbella.io/api/v1/web/msciabar-zc3thebgxgh/default/chess).

# IBM Cloud

The IBM cloud was the original cloud offering OpennWhisk.

![IBM](030.png)

You need to download anmd install the `ibmcloud` cli in order to deploy actions in it. There are also some requirements like downloading a plugin and to target a space; all the steps are explained in their website. 

They have a generous free offering for run ning functions. You just need to register to the website to use a very large number of function invocations for free. 

Once you downloaded the tool, the commands to deploy the chess engine and get an URL to run the action are:

```
ibmcloud login -u "$IBMUSER" -p "$IBMPASS"
ibmcloud fn action update chess chess.zip --kind go:1.11
ibmcloud fn action get chess --url
```

[Follow this link to play Chess on IBM Cloud](https://eu-de.functions.appdomain.cloud/api/v1/web/a1d40f6b-e5e3-4f07-8f92-77b525392253/default/chess)

# Naver

Naver is a Korean company, owner of the main search engine in the Korean language, but also offering clod services. Their Naver Cloud Platform uses OpenWhisk to implement cloud functions.

![Naver](040.png)

Currently Naver does not offer a cli to deploy actions, however I was told a cli is actually under development. For now I deployed the chess action using their web interface.

![Naver Deploy](041.png)

[Follow this link to play Chess on Naver](https://wka9bi13u3.apigw.ntruss.com/chess/chess/ZC2o7bFh0x/http)

# Adobe IO

Adobe has a serverless offer based on OpenWhisk, too. It is called the Adobe I/O Runtime.

![Adobe IO](045.png)

Adobe currently supports only Nodejs based runtimes, so if you pick them as your serverless function providers you have to write your serverless functions in Javascript. However being based on OpenWhisk, it runs also our chess engine. 

I had to ask to Adobe staff to deploy my action for demonstration purposes, and they kindly agreed.

[Follow this link to play Chess on AdobeIO](https://whisk-chess.adobeioruntime.net/api/v1/web/default/chess)

# Custom on AWS

Finally, you can run OpenWhisk in any cluster supporting Kubernetes. For this purpose, I created a EKS cluster on AWS and installed OpenWhisk on it, then I deployed my chess server. I will show here how to do that quickly and easily.

![AWS](053.png)

Before all you need to install and configure an AWS account. I refer to AWS documentation for informations how to do this.

Once you have an account I installed the  [`eksctl`](https://eksctl.io/) tool that makes easy to create a Kubernetes cluster on  AWS. 

Also you need to install the [`helm`](https://helm.sh/) deployment tool and use it to actually install OpenWhisk and download the helm chart from GitHub to install OpenWhisk as follows:

```
git clone https://github.com/apache/openwhisk-deploy-kube
cd openwhisk-deploy-kube/helm
```

Once everything is ready your can create a Kubewernetees cluster and install OpenWhisk with just 3 commands:

```
eksctl create cluster --name openwhisk
eksctl create nodegroup --cluster openwhisk --node-labels openwhisk-role=invoker
helm install --set whisk.ingress.type=LoadBalancer openwhisk ./openwhis
```

The cluster creation will take a while. Once it is completed you will get your private OpenWhisk running in AWS, and you can deploy your chess action  in it. 

For vanilla OpenWhisk you have to use the `wsk` command to deploy in OpenWhisk. You have aloo to retrieve the location of the OpenWhisk apache entry point, and the authorization key and pass them to the `wsk` tool. The required commands are:

```
cd whisk-chess
APIHOST=$(kubectl  get svc | awk '/openwhisk-nginx/ { print $4}')
AUTH=$(cat openwhisk/values.yaml |  awk '/guest/ { print $2}' | tr -d '"')
wsk property set --apihost http://$APIHOST --auth $AUTH
```

It is important to note that we configured  an insecure setup because we are accessing to OpenWhisk over the unencrypted http protocol. 

In a real world setup you will need additional steps to setup an https endpoint with a certificate. There are detailed informations in the [helm chart github repository](https://github.com/apache/openwhisk-deploy-kuhttps://github.com/apache/openwhisk-deploy-ku).

Once you retrieved the informations you can deploy your chess app, and get the URL.

```
wsk action create chess chess.zip --web true --kind go:1.11
wsk action get chess --url
```

I cannot provide an URL as I a destroyed the cluster after the testing, however you can see the result in the image at the beginning of the paragraph.



