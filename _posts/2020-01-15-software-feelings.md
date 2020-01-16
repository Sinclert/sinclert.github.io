---
title: "Social implications of software"
layout: post
date: 2020-01-15 20:00
image: /assets/images-posts/mental-health.png
headerImage: true
tag:
- software
- personal
- feelings
category: blog
author: sinclert
description: "Specially useful for not software people, as it may help to understand us better"
---


## Introduction

**This post is very personal and opinionated. You may have a different opinion, and that's fine.**

I recently read that what defines a good Software Engineer (_S.E._) is the ability to switch between levels of abstraction 
in a relative quick and easy manner. I do not fully agree with that statement, as I think there are other qualities to
describe a good S.E, but it definitely shows how important abstraction capacity, and complex thinking is within our
work field.

The constant usage of this abstract thinking often generates disconnection from reality, and may cause people around us 
to see us as _anti-social people_ that do not even know how to communicate properly. Here is my take about why
this phenomenon occurs, which are the effects to our social skills, and how I feel about it.


## The nature of our work

Software has one of the most flexible learning curves of any field. Learning how to do basic operations can take 
as little time as minutes, given that it does not require us to understand what is going on under the hood to work with it.
Therefore, one can go as deeper as desired, internalizing the implications of coding this or that other way;
learning this or that design pattern, or expecting this or that much traffic...

As an example, I will illustrate what my mind considers when designing a project:

_Imagine you are building a simple application, that allow people to upload pictures of hand-written notes,
to be transformed into digital text._

Just by reading that previous statement, I have already thought:

- This lays into a typical Front-Back architecture.
- The _Front-end_ (user interface) would be a mobile app, and/or a web UI.
- There is no data model to be designed, as what the application offer can be performed without a database.
- The _Back-end_ (server side) steps are clear:
    - Image standardization.
    - Text detection.
    - Text cleaning.
    - Text analysis.
    - Output generation.
- The _Back-end_ (server side) would need some:
    - Optic Character Recognition (OCR) piece.
    - Web-server piece.
    - Image processing piece.
- I know testing frameworks usually determine project folder structure, so I will review that first.
- The most critical part is clearly the OCR software.
- The most critical part, the OCR, is desired to be performed _locally_, instead of connecting to some cloud provider
(Google, Amazon, Microsoft...) that may have that functionality.
- Why, you ask? Because that would imply both a network overhead, and some additional billing.
- Library selection is important, and the place to look for them is [GitHub](https://github.com).
- The best libraries are the ones with a good balance between:
    - The most _stars_.
    - The most recent release.
- Why, you ask? Because that implies that the library is currently maintained, so the original authors may be
happy to solve any problem that piece of software may have, once we dig into it.
- The application need to be made publicly available using a cloud server.
- Having alerts in case the application crashes, is a good feature to decide for one or another cloud provider.

As you see, nothing of the previous thoughts are complex _per se_, but they involve understanding the implications of
software development, being able to see problems in advance, designing good architectures, understand the risks of
external dependencies and so on.

All of that without typing a single key.


## How abstraction affect us

I believe, because I have personally suffer it, that spending several days working on something that requires lots
of concentration and complex thinking, can lead to short-term poor speak and phrasing abilities. I also believe that
this speak deterioration portraits a _"poorly-social"_ version of us, which does not represent how we are and how we
communicate with each other. This effect becomes very clear when we find ourselves in situations when we speak with
people whose job involves, dealing with people, in a day to day basis (lawyers, professors, scientists, journalists...).

Let's think of an example.

It is Friday night, and after a whole week of very hard debugging sessions spending all work time in silence going
through some pieces of documentation, you are about to attend this Friday party with your best friend. Once you arrive,
you talk to the organizers, the attendees... and you start to feel like everyone is way more well-spoken than you.
You know you are a good speaker, that you are funny, but somehow, in that situation, you are clearly not feeling good.

_It feels like most of them are a couple of gears higher than you, communication speaking._

I think this is a real feeling, shared among lots of us, but hard to explain.

My explanation for this phenomenon is the following: when an activity requires some specific mental skill set to be boosted,
we need some time (actual days), to shift our mindset to perform well in that activity. Coming back to _"neutral mindset"_
requires some additional days. Therefore, following with the previous example, if we are working at 6:00pm on Friday and 
attending a party that same day at 9:00pm, there has not been enough time for us to shift into our more socially-friendly
mindset again.

Bottom line is: **programming pushes us to tune our mindset to excel in certain areas**. That mental shift takes time to
recover, so if you find yourself working Monday to Friday on something that pushes that shift, is hard to show your real
communication abilities, and work to improve them.


## Personality biased

Up to this point, the non-obvious social implications that I think software development enforces on people, should be clear.
These implications are mostly negative, as they involve a **trade off between working performance and social skills**, and
most of the people would not like to join this trade off.

That's why good S.E. are so well paid, and that's why not every money addict is willing to jump into a S.E. carer, 
as well as they do to a Business one.

That trade-off is keeping the balance.

Do not get me wrong, I think everyone can jump into a S.E. career and do great. I truly believe so.
However, most people are not willing to sacrifice short-term social skills for their work progression,
so it quickly becomes a burden. To be honest, no one wants, but there is a specific type of people who have
less problems with doing so.

Introverts.

See, I understand introvert behaviour by the times a given person wants to socialize, **not about the quality of the social
interactions**. Obviously everyone, independently of their inner personality, want to enjoy some quality social time with
their relatives, friends, and significant other. It is the amount of times you are willing to do so per week, more than
the quality of those interactions, what defines your _introvert_ personality.

At this point, I feel comfortable concluding:

**1. It is easier for introverts to bear this social skills degradation trade-off**, given that
they were not willing to socialize that much in the first place.

**2. Software is dominated by introverts**. Not because S.E. promotes less socialization, but because only those 
who are comfortable with socializing once a week, do not see that trade-off as an actual burden.


## Some references

- [Linus Torvalds TED talk](https://www.ted.com/talks/linus_torvalds_the_mind_behind_linux). (00:00 - 02:00 on how S.E. conditions usually are).
- [TechLead programmer habits](https://youtu.be/W8ykZNSLDqE?t=630) (10:30 - 14:30 on programming loneliness).
