---
id: 1764085651-site-reliability-engineering-sre
aliases: [Site Reliability Engineering (SRE)]
tags: [devops, observability, notes]
publish: true
created: 2025-11-25 23:47
modified: 2025-11-26 00:43
title: Site Reliability Engineering (SRE)
---

# Site Reliability Engineering (SRE)
> So, I want to write this because I have found in Facebook post have talk about that, and I did not know what was that before, so wanted to learn it too. 
## Definition
By Amazon (AWS), SRE is the practice of using software tools to automate IT infrastructure tasks such as system management and application monitoring.[^aws] It's really related with SLAs, SLIs, and SLOs. 

SRE helps software development teams by providing metrics, logs, and traces as part of observability. Monitoring, in the SRE context, means collecting critical information that reflects system performance. The metrics SRE teams monitor are chosen by developers, who decide which parameters are critical to an application's health. These typically include latency, traffic, errors, and saturation (the "four golden signals"), which together give insight into the system's reliability.

SRE is essentially the practical implementation of DevOps.
> [!TODO]
> Needs more info about it, like it's can both work together?

[^aws]: AWS – *What is Site Reliability Engineering (SRE)?*. https://aws.amazon.com/what-is/sre/ (accessed 2025‑11‑25).