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

This aritcle will provide guidance and configurations for a base HTTP-LB setup with recommended settings from field teams that have worked with customers to deploy thousands of HTTP LB's 
and related objects includingsetting for origin pools, health checks, base security, timeouts, etc...

Covered Topics:
--------------------------

   * Origin Pool Settings
   * Health Checks
   * Routes
   * Web Application Firewall
   * DoS Settings
   * Common Security Controls
   * Other Settings

Origin Pool:
---------------------------

Origin Pool is a mechanism to configure a set of endpoints grouped together into a resource pool used in the load balancer configuration.  The main functions that 
an origin pool is responsible for is the following:

   * Discovery of Endpoints
   * Load Balancing Between Endpoints
   * Health Checks for Endpoints
   * TLS Capabilities to Endpoints






