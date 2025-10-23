.. meta::
   :description: F5 Distributed Cloud HTTP LB Field Recommended Settings
   :keywords: F5, Distributed Cloud, HTTP-LB, Settings
   :category: Field-Sourced-Content
   :sub-category: how-to
   :author: Steven Iannetta

.. _http_lb_field_recommended_settings:

Distributed Cloud HTTP-LB Field Recommended Settings
=====================================================================================

Guide is a Work In Progress
--------------------------

Introduction
--------------------------

This document provides guidance and recommendations for establishing a foundational HTTP Load Balancer (HTTP-LB) configuration.  The suggested settings are based on
practices gathered from field teams with extensive experience deploying HTTP-LBs and related objects within customer environments for PoV purposes or to establish a baseline deployment model.
Since this is not an exhaustive configuration guide it should be utilized as a starting point to support customers in their Distributed Cloud journey and inital deployments of HTTP-LB.
Customers are encouraged to customize and adapt these recommendations to meet their specific requirements and deployment scenarios.

.. figure:: ./images/recommended_practices/http_lb_intro.png
   :align: center

Covered Topics:
--------------------------

   * Recomended Settings (TLDR Version)
   * Domains and Certificate
   * Origin Pool Settings
   * Health Checks
   * Routes
   * Web Application Firewall
   * DoS Settings
   * Common Security Controls
   * Other Settings

Recommended HTTP-LB PoV Settings:
---------------------------

.. note:: Domains and Certificates:

Dependent on client application, but for a PoV the follwoing settings are the most common.  Utilize Auto-Cert capability for domain and certificate, add the HTTP Redirect to HTTPS,  add HSTS Header, Listener Port 443, 
Client Side TLS High setting, both HTTP/1.1 and 2 Protocol


.. figure:: ./images/recommended_practices/domains_certs_pov_settings.png
   :align: center

Origin Pool:

Using this origin pool as a Fallabck only as we will use routes for primary application as this will provide more flexibility for any current or future requirement for layer 7 routing options.

Set a name and configure the Origin Discovery.  Recommended to use IP in this example we are using a public IP Address, Connection Pool Reuse, Same Health Check Port as Origin, 
Accept the Load Balancing Algorithim, Local Endpoints Preffered, and Server Side TLS options as Host Header.

.. figure:: ./images/recommended_practices/origin_servers_config.png
   :align: center

.. figure:: ./images/recommended_practices/server_side_tls.png
   :align: center




Domains and Certificates:
---------------------------
Below is a screen shot of the options for an "HTTP LB Domains and LB Type" settings.

.. figure:: ./images/recommended_practices/domains_certs.png
   :align: center

Options and Settings for Domains:
   * Can have up to 32 Domains Per HTTP-LB
   * Wildcard prefix is supported (example in picture above)
   * SAN Certificates are supported
   * Auto Certificate utilizes Let's Encrypt for a Primary Domain Delegated to Distributed Cloud DNS.  There is an option for Auto Certificate with user managed DNS.  Customer needs to buildout the challenge record manually in their DNS or build any automation they prefer.

Typical Domain and Certificate Settings for a PoV:

.. figure:: ./images/recommended_practices/domains_certs_pov_settings.png
   :align: center

Origin Pool:
---------------------------

Origin Pool is a mechanism to configure a set of endpoints grouped together into a resource pool used in the load balancer configuration.  The main functions that 
an origin pool is responsible for is the following:

   * Discovery of Endpoints
   * Load Balancing Between Endpoints
   * Health Checks for Endpoints
   * TLS Capabilities to Endpoints

* `F5 XC Creating Origin Pool <https://docs.cloud.f5.com/docs-v2/multi-cloud-app-connect/how-to/create-manage-origin-pools>`_.

Origin Pools have many options as you can see in the few pictures below.

.. figure:: ./images/recommended_practices/origin_settings.png
   :align: center


.. figure:: ./images/recommended_practices/origin_discovery.png
   :align: center


.. figure:: ./images/recommended_practices/origin_tls.png
   :align: center


Typical Domain and Certificate Settings for a PoV:



