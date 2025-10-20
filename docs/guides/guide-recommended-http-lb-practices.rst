.. meta::
   :description: F5 Distributed Cloud HTTP LB Field Recommended Settings
   :keywords: F5, Distributed Cloud, HTTP-LB, Settings
   :category: Field-Sourced-Content
   :sub-category: how-to
   :author: Steven Iannetta

.. _http_lb_field_recommended_settings:

Distributed Cloud HTTP-LB Recommended Settings
=====================================================================================

This repo will provide a guide and how to configurations to configure an HTTP-LB with some recommended settings from field teams that have worked with customers to deploy thousands of HTTP LB's 
and related objects including but not limited to security.

CDNs are essential to delivering performant web applications, especially when serving static assets, 
such as stylesheets, scripts, images, fonts, and other cacheable resources. In this article, we will explore how to deploy a CDN distribution 
behind an HTTP Load Balancer (LB) in F5 Distributed Cloud (F5 XC) and configure a regular expression (regex)-based route to direct specific 
file types—like css, js, jpg, png, and others—to the CDN for caching and accelerated delivery.

Using this architecture, your load balancer acts as the central entry point, and traffic is routed intelligently using regex rules. 
Cacheable file types are sent to the CDN distribution, while all other requests can be forwarded to other services, such as origin servers or APIs. 
This approach gives you both flexibility and control over application-level routing while adding a security control point at the HTTP-LB.