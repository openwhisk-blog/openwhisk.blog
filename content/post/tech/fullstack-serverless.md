+++
author = "Michele Sciabarrà"
title = "Nimbella and Netflify Integration"
date = "2020-10-06"
description = "Integrating Nimbella with the larger Serverless ecosystem"
tags = [ "Nimbella" ]
hidden = true
+++

The serverless approach is evolving towards an ecosystem of interconnected services in the cloud, where each service does its part at best and cooperate smoothly with other services.

Nimbella is very strong in providing Server Side functions. One of its innovations is the ability to code in the "serveless" but developing maintaining a state. It is generally a good solution for all your API and geric backend needs.

Nimbella also offers an integrated solution for deploying also front-end code, offering a a single shop to deploy a full serverless applications. Nonetheless, there are other serverless providers offering a lot more when it comes to deploying the front-end part. For example, [Netlify](https://www.netlify.com/).

## Netlify and static site generation

Netlify is specialized in deploying static web sites. It integrates well with Git as a content storage. It has a good support for static sites generators, and there are lots of them around. I can mention [Jekyll](https://jekyllrb.com/), [Gatsby](https://www.gatsbyjs.com/), [Hugo](https://gohugo.io/) and [many others](https://www.staticgen.com/jekyll).

To run a static site generator, you generally need to run it locally to edit your content in some textual format like markdown. Once you finished with your content, you execute a build step to generate actual HTML/CSS/JavaScript code. Finally, you can upload the result to some form of web storage.

The procedure is complex enough to make sense to have some service provider doing the work for you. Netlify is one of those providers. If you check the websites of many of those website generators, you can generally find a button "Deploy to Netlify".

![](netlify.png)

What this button does? It  creates a standalone git repository to store your content, then automatically builds and deploys the site in Netlify servers. It uses the accumulated knowledge of how static site generators works and automate all the builds for you.

In short, if you click on one of those buttons, Netlify will deploy the website in their systems. Netlify offers a free tier to run sites with a limited number of users, you have to pay only if your site reaches a large number of visitors and page views.

Static sites are awesome for documentation, company profiles or blogs, but definitely does not cover all the possible uses cases. Basically all the interesting web applications are dynamic in nature and needs to keep a state. Here is where Nimbella shines.

When you combine the power of Netlify to deploy the front-end code with Nimbella ability to create server side backend with state, you have on the path to build large web applications and website completely serverless.

## A stateful application on Nimbella and Netlify

There are plenty of examples of static websites on Netlify so if want to setup your blog, all you need is to pick a static site generator, deploy it and edit the content, either manually or using one of the many available online editors.

However, there are not so many examples of a full, stateful serverless applications including a backend and a frontend that you can deploy on Netlify that are both stateful and serverless. So I developed one.

I developed a personal bookmark manager, an application that vaguely resembles a personal version of the now defunct *del.icio.us* website. I called it *nimbelicious*.

The key feature is that is a stateful application, so it demonstrate the power of Nimbella Serverless, but it also has a significant front-end that needs to be built, leveraging Netlify power in automating front-end automation deployment. You can see the application in *Figure 1*.

![](sample.png)
*Figure 1*

As it is a personal bookmark manager, the application is password protected, and this is a first statefulness requirement. Your installation is only yours and it is different other people installation. 

You get your URL to access it, you use your password and keep your data. There is no username as it is supposed to be single user. However it can be accessed by multiple devices, so data is definitely stored in the cloud, not in your local brower.

As you can see in the *Figure 1*, after login it shows a tag cloud, allowing to to more tags. Selecting a tag shows a list of URLs. You can add more (and remove them, of course). 

The nice thing is that you can deploy this application for you personal use on Netlify+Nimbella. Given the expected usage for such a personal bookmark manager is not high, you can use it with the free tier of both Nimbella and Netflify. 

In the process, you can get a glimpse of the future of serverless. This approach of deploying applications in the cloud is going to become standard and widespread.

## How to deploy

Let me describe now how to deploy Nimbelicious. First, note that both Nimbella and Netlify authenticate against GitHub. Furthermore, Netlify expects you are going to keep your content in git, so you need an account in GitHub  as a prerequisite. I assume here you already have such an account and your browser is already logged in. In *Figure 2* there is an diagram of the steps required to deploy.

![](deploy.png)
*Figure 2*

Go to the [Nimbelicious GitHub repo](https://github.com/openwhisk-blog/nimbelicious) and click on the button *Deploy to Netlify+Nimbella*. 

It will open a page in the Netlify portal in order to configure your new website.

If you click "Connect to GitHub" it will proceed authenticating against GitHub (hence you need an account there) and it will create also a repositore. In Netlify logic, a git repository is essential since it is where you are expected to stores your content.  If you are already logged in GitHub (recommended) it will just create an empty repository then deploy to Netflify.

In the second step Netlify asks for configuration parameters. Nimbelicious is configured to ask for two piece of informations. One is the password to protect you Bookmark Manager. Pick one. The second is a Nimbella Login Token. You have to get one as described in the following paragraph. Once you have it, paste it and you are done. Netlify starts to build the website and in the process also deploys Nimbella actions.

# Getting a Nimbella login token

Currently,  you need to register in Nimbella to be able to get an account. In the future this step may be automated, but currently you need a Nimbella login token, so you have to follow the procedure in *Figure 3* to get it.

![](gettoken.png)

Without closing the browser window showing Netlify, open another tab and go on [nimbella.com/signup](https://nimbella.com/signup). You can register here a free Nimbella account, and get an account that also includes redis to store data. After registering you get to the page  *Getting Started in 60 Seconds*. If you are already registered, you reach this page opening the menu below your avatar, and selecting "Setup Nimbella".

Here you can see the full a command to log into Nimbella in the form `nim auth login <token>`. You need to copy only the `<token>` part. It usually starts with `ey`. Once you copied it, and paste it back in the Netfly screen asking for the token, to complete your deployment.

## What happens now?

After you deployed your application, Netlify starts a build. It will checkout the source code of the application, setup an appropriate environment, download the required dependencies and deploy the website. In our case it is both the front-end and the backed-end code. After a (short) while you will get your new shiny website in Netlify talking with backend serverless functions in Nimbella. 

Once deployed Netflify will assign a random website name, something like `happy-einstein-eac396.netlify.app`. You can configure the website as shown in *Figure 4* as the generated name may not be easy to remember. If you don't like it, you can change it.

![](config.png)
*Figure 4*

To change site name just login in Netlify, select your site and go in `Site Settings`. You will see a long list of options; we are interested in `Site Details`. In this form you can easily change the site name to something easier to remember. As long as you are not picking something already in use, you can give the name you prefer in the domain `netlify.app`. You can also give your custom domains and do a lot of other things that I do not cover here. 

Last but not least I advise to check the publishing logs as it is pretty interesting and also very important to locate build problems. In the same screen showing the publishing status of your web site, you can scroll down and find the list of the deployments.   If you click on the arrow it will show the log of the deployment that you can inspect to look for errors. Every time you commit to github, it will trigger a build. 

![](develop.png)
*Figure 5*

Since everything is source code you can go edit and customise easily the application. If you click on the link `GitHub` as shown in *Figure 5* it will bring you to the GitHub repository from where you can download the source code with git.

You can then run git commands like

`git clone <your-repository-url>` and edit the source code.

I will not cover here the details of front-end and back-end development but you have now here a complete serverless application that you can edit and modify as you like. You can use the [Nimbella tools](https://nimbella.io/downloads/nim/nim.html) to do the complete development of the application, front-end and backend, and test it. 

It is of course recommended you use a different namespace than the one you picked for publishing the website to avoid affecting the published website.

When you finished, just `git push` back your changes and application and the Netlify+Nimbella integration will update both the frontend and backend in production.

## Conclusions

We just demonstrated how you can get a personal application and deploy in the cloud with a single click. Deploying an application in the cloud, even as simple as this, used to require a significant effort. You had to deploy a server and manually install it, or write the deployment scripts. 

Now with the fully automated serverless approach, deployment is one click away, and a full deployment pipeline is in place, allowing to change and update code and content of your website, having to worry only of the code and not of the infrastructure. 













