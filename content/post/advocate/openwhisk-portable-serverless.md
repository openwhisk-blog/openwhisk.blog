+++
author = "Michele Sciabarrà"
title = "Apache OpenWhisk is a truly portable Serverless Platform"
description = "Want to see a serverless action playing chess running on multiple public clouds from multiple vendors, such as Adobe IO Runtime, IBM Cloud, Naver, and Nimbella? Read on..."
date = "2020-09-18"
tags = [ "Advocate" ]
aliases =  [ "/portability/" ]
+++

# TL;DR 

Apache OpenWhisk is a truly portable and multiplatform Serverless engine and it is available now on all the major clouds from multiple commercial vendors. Here is a Chess Engine running on:

- [Adobe IO](https://whisk-chess.adobeioruntime.net/api/v1/web/default/chess)
- [IBM Cloud](https://eu-de.functions.appdomain.cloud/api/v1/web/a1d40f6b-e5e3-4f07-8f92-77b525392253/default/chess)
- [Naver](https://wka9bi13u3.apigw.ntruss.com/chess/chess/ZC2o7bFh0x/http)
- [Nimbella](https://apigcp.nimbella.io/api/v1/web/msciabar-zc3thebgxgh/default/chess)

And see below for instructions how to run it also locally and in any Kubernetes cluster, for example AWS EKS...

<iframe width="560" height="315" src="https://www.youtube.com/embed/02Xezhf_j4U" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

{{< youtube 02Xezhf_j4U  >}}

# OpenWhisk?

Apache OpenWhisk is a Serverless Cloud Platform, developed as an open source project at the Apache Software Foundations.  It is similar to Amazon Lambda, Google Functions or Azure Functions. The main difference is that it is an Open Source project, it is offered by multiple commercial vendors, and it has a rich serverless programing model for composing functions into workflows.

Many vendors today offer cloud functions based on OpenWhisk, and it runs on all the major public clouds. However not all the vendors disclose where they run their services, so I will refer to the vendor and not to the cloud that runs it. It can also be installed on any Kubernetes cluster, so you can install in any cloud, either your private cloud or the public one you prefer.

In this article I am going to show that OpenWhisk is a truly portable serverless solution, and that you can write a single serverless application and then run it on multiple vendors.

To prove my point, I wrote an open source serverless application and ran it on all the OpenWhisk vendors I got access to. I also created a custom Kubernetes cluster and installed OpenWhisk on it to run my application.

The application is a chess engine, written in the Go programming language, and that includes backend and frontend. You can use it to play chess using a web interface, while the opponent is an AI algorithm running as a serverless function in OpenWhisk.

# Local Deploy

For testing and development you can use the Standalone OpenWhisk. It is a single node installation that can run in your machine and only requires [`Docker`](https://docker.com) to run. You also need to download the [OpenWhisk CLI tool `wsk`](https://github.com/apache/openwhisk-cli/releases/tag/1.0.0) for your operating system in order to interact with OpenWhisk.

Once prerequisites are satisfied, you can start a local OpenWhisk with the following command:

```
bash <(curl -sL https://s.apache.org/openwhisk.sh)
```

The command will download a Docker image for standalone OpenWhisk and it will start it. It will also open the playground, that you can use to create and run a function on the fly from your browser.

![Playground](playground-ui.png)

Once you have OpenWhisk up and running you can configure the `wsk` tool to access it.  OpenWhisk access is protected by a key that you have to retrieve and use to configure `wsk`, as follows:

```
AUTH=$(docker exec openwhisk wsk property get --auth | awk '{ print $3}')
wsk property set --auth $AUTH --apihost http://localhost:3233
```

# Building and testing our Chess Action

Now let's build our chess engine and use the local OpenWhisk  to test it locally. The source code of the chess engine [is available on GitHub](https://github.com/openwhisk-blog/whisk-chess).

The code is based on a freely available chess engine called [CounterGo](https://github.com/ChizhovVadim/CounterGo/pulls). It is written in Go. I adapted it to run as a stateless serverless action, and I added a frontend in JavaScript,  using the libraries [Chessboardjs](https://chessboardjs.com) and [chess.js](https://github.com/jhlywa/chess.js).

In order to build the action, you need common tools like `git`, `make` and `docker`. Once you have them you can download and build the sources with the commands:

```
git clone https://github.com/openwhisk-blog/whisk-chess
cd whisk-chess
make
```

Note that you do not need a Go compiler to build the action, just Docker, as you can compile the action using the OpenWhisk Go runtime itself. The result is the file `chess.zip` containing a pre-compiled Go action ready to be deployed.


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

Now let's start deploying our chess in the services of the various vendors that offer OpenWhisk.

[Nimbella](https://nimbella.com) offers a serverless solution based on OpenWhisk and focused on providing an "awesome developer experience". 

I think it is  appropriate to say that I work for Nimbella, but I am trying to be neutral in this article and offer  a fair comparison of all the OpenWhisk vendors I am aware of.

![Nimbella](020.png)

Nimbella uses its own CLI called `nim` for deployment. The Nimbella CLI was recently [open sourced](https://github.com/nimbella/nimbella-cli/). You need to sign-up and login to use their service. Once you are logged in, you can deploy our chess action and get an URL for it. The `nim login` command conveniently permits sign-up.
The CLI is available [for download](https://nimbella.io/downloads/nim/nim.html#install-the-nimbella-command-line-tool-nim) for Mac OS, Windows and Linux.

```
nim login
nim action update chess chess.zip --kind go:1.12 --web true
nim action get chess --url
```

It is possible to use the `wsk` CLI with Nimbella if one prefers it. You'll notice the command is identical here to the one shown earlier but replaced `wsk` with `nim`.

[Follow this link to play chess on Nimbella](https://apigcp.nimbella.io/api/v1/web/msciabar-zc3thebgxgh/default/chess).

# IBM Cloud

The IBM cloud was the original cloud offering OpenWhisk as a service.

![IBM](030.png)

You need to download and install the `ibmcloud` CLI in order to deploy actions to IBM. There are also some requirements like downloading a plugin and to target a space; all the steps are explained on their website.

They offer a generous free tier for running functions. You need to register on their website to use a very large number of function invocations for free.

Once you downloaded the tool, the commands to deploy the chess engine and get an URL to run the action are:

```
ibmcloud login -u "$IBMUSER" -p "$IBMPASS"
ibmcloud fn action update chess chess.zip --kind go:1.11
ibmcloud fn action get chess --url
```

[Follow this link to play Chess on IBM Cloud.](https://eu-de.functions.appdomain.cloud/api/v1/web/a1d40f6b-e5e3-4f07-8f92-77b525392253/default/chess)

# Naver

Naver is a Korean company, owner of the main search engine in the Korean language, but also offering cloud services. The Naver Cloud Platform uses OpenWhisk to implement cloud functions.

![Naver](040.png)

Currently Naver does not offer a CLI to deploy actions, however I was told a CLI is actually under development. For now I deployed the chess action using their web interface.

![Naver Deploy](041.png)

[Follow this link to play Chess on Naver.](https://wka9bi13u3.apigw.ntruss.com/chess/chess/ZC2o7bFh0x/http)

# Adobe IO

Adobe has a serverless offering based on OpenWhisk too. It is called the [Adobe I/O Runtime](https://www.adobe.io/apis/experienceplatform/runtime.html).

![Adobe IO](045.png)

Adobe I/O Runtime currently supports only Node.js based runtimes, so if you pick them as your serverless function providers you have to write your serverless functions in JavaScript. However being based on OpenWhisk, it is possible to use other runtimes by request, and so we can also run our chess engine. I thank the team at Adobe for their kind support and help in deploying my action for demonstration purposes.

[Follow this link to play Chess on AdobeIO.](https://whisk-chess.adobeioruntime.net/api/v1/web/default/chess)

# Custom on AWS

Finally, you can run OpenWhisk in any cluster supporting Kubernetes. For this purpose, I created an EKS cluster on AWS and installed OpenWhisk on it, then I deployed my chess application. I will show here how to do that quickly and easily.

![AWS](053.png)

You will need to create and configure an AWS account. I refer you to AWS documentation for information how to do this.

Once I created an account, I installed the  [`eksctl`](https://eksctl.io/) tool that makes easy to create a Kubernetes cluster on AWS.

Also you need to install the [`helm`](https://helm.sh/) deployment tool and use it to actually install OpenWhisk. You can download the helm chart from GitHub and install OpenWhisk as follows:

```
git clone https://github.com/apache/openwhisk-deploy-kube
cd openwhisk-deploy-kube/helm
```

Once everything is ready your can create a Kubernetes cluster and install OpenWhisk with just 3 commands:

```
eksctl create cluster --name openwhisk
eksctl create nodegroup --cluster openwhisk --node-labels openwhisk-role=invoker
helm install --set whisk.ingress.type=LoadBalancer openwhisk ./openwhisk
```

The cluster creation will take a while. Once it is completed you will get your private OpenWhisk service running in AWS, and you can deploy your chess application to it.

You can use the `wsk` or `nim` CLIs to deploy to OpenWhisk. You have to retrieve the location of the Apache OpenWhisk entry point, and the authorization key and pass them to the CLI tool. The required commands using `nim` are:

```
cd whisk-chess
APIHOST=$(kubectl  get svc | awk '/openwhisk-nginx/ { print $4}')
AUTH=$(cat openwhisk/values.yaml |  awk '/guest/ { print $2}' | tr -d '"')
nim auth login --apihost http://$APIHOST --auth $AUTH
```

It is important to note that we configured an insecure setup because we are accessing OpenWhisk over the unencrypted HTTP protocol.

In a real world setup you will need additional steps to setup an HTTPS endpoint with a certificate. You will find relevant details in the [helm chart GitHub repository](https://github.com/apache/openwhisk-deploy-kuhttps://github.com/apache/openwhisk-deploy-ku).

Once you retrieved the API host and authentication key, you can deploy your chess app, and get the URL.

```
nim action create chess chess.zip --web true --kind go:1.11
nim action get chess --url
```

I cannot provide a URL in this case as I a destroyed the cluster after testing, however, you can see the result in the image at the beginning of the paragraph.
