---
title: "What is a reverse proxy anyway?"
layout: post
date: 2020-03-01 20:00
image: /assets/images-posts/proxies.png
headerImage: true
tag:
- software
- architecture
- networks
category: blog
author: sinclert
description: "Clarifications surrounding what reverse proxies are"
---


## Introduction

Even after some years dedicating myself to software engineering, and having a relatively good understanding of
big applications component architectures, there was a specific resource that I could not get my head around,
at least until recent months.

I am referring to what gets called, _"Reverse Proxy"_.

In this post I will get into the details of what is it, where does it gets its name from,
and the common misunderstanding around this specific resource.


## A nomenclature nightmare

In order to clearly understand what people refer to when they talk about _"Reverse Proxy"_, it is better to start
by looking at the big picture when considering a big software application, and its relationship with the network
(or how [Moss refers to it at _"IT Crowd"_](https://www.youtube.com/watch?v=iDbyYGrswtg): _"The Internet"_).

The architecture would contain (from left to right):
- A set of clients (web, mobile apps...).
- An **optional** "Proxy" that some clients may decide to use.
- "The Internet" (usually represented by a cloud icon).
- Some sort of _"Load Balancer"_ to distribute requests.
- A set of server replicas.

Ok, I will stop right here.

You may be thinking: _Ok, so, you are trying to explain what a "Reverse proxy" is, and this article has only named
"Proxies" and "Load Balancers". Where are the "Reverse proxies"?_

The _"Reverse Proxy"_ architecture location, and the reason why it has that name, are hidden in the previous list
of network-related components, even though they are not obvious at first sight.
**This is why the section is called nomenclature nightmare**. 🤦🏻‍♂️ 


## Reverse Proxy: what is it

A _"Reverse Proxy"_ is defined as:

_"A Type of proxy server that retrieves resources on behalf of a client from one or more servers, implementing several
functionalities such as: caching, contents compression, distribution of requests, and / or security procedures"._

Following that definition, a _"Reverse Proxy"_ is what lays between _"The Internet"_ and the set of servers replicas.
However, the component placed in that spot during the components listing was previous referred to as _"Load Balancer"_.
Well, **a _"Load Balancer"_ is nothing more than a sub-type of _"Reverse Proxy"_**, that only implements 
one of its functionalities: redistribution of request among several server replicas.

Therefore, we can conclude that a Reverse Proxy is a **generic figure**, referring to a network component placed
between _"The Internet"_ and the set of servers, and implementing some of its original functionalities.


## Reverse Proxy: the misunderstandings

### The 'reverse' word

A common misunderstanding surrounding the term comes from the usage of the _"reverse"_ word in its name.
This word is very confusing as it is not clear what _"reverse"_ refers to, in order to be considered that way.

The word "reverse" refers to the fact that these components are placed in the opposite / reverse position,
**with respect to _"The Internet"_**, than the regular "Proxy". That is not that obvious at plain sight,
but it may become a bit more clear just by changing the very generic "Proxy" name, by _"Forward Proxy"_.
Now we are talking.

### The hidden presence

Another root of confusion is the fact that, even if the _"Reverse Proxy"_ figure is usually present in big scale
application diagrams, it is hard to find references to it in some of the orchestrator systems used nowadays.

Just consider Kubernetes, and its [services documentation](https://kubernetes.io/docs/concepts/services-networking/service/).
Kubernetes give developers a very easy way of deploying _"Load Balancers"_, as it is one of the native subtypes of "services"
that it provides. However, the term _"Reverse Proxy"_ is **only mentioned one time in the whole "services" documentation**,
making hard to realize that some of the services developers are able to deploy, are just sub-types of a bigger general
figure called _"Reverse Proxy"_.