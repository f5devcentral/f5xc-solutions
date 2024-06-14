.. meta::
   :description: F5 Distributed Cloud Customer Edge Centos to RHEL OS Conversion Example
   :keywords: F5, Distributed Cloud, Customer Edge, Centos, RHEL, 

.. _ce_os_migration-centos_to_rhel:

Distributed Cloud Customer Edge Centos to RHEL OS Migration
==========================================================================

This repo will provide a solution to introduce a process to migrate a Customer Edge site from
End of Life Centos OS to RHEL Operating System.

Introduction
------------
Back in December 2023 Distributed Cloud Customer Edges image was based on Red Hat Enterprise Linux or RHEL Operating System  
Prior to that the Customer Edge ran on Centos 7.x Operating System which has been announced End of Life .
The goal of this guide is to provide a migration strategy from Centos to RHEL OS for customer edge sites that are in a SaaS-Hybrid Edge Deployment
pattern (option #2 in image below) where the VIP is on the Regional Edge and the tunnel termination and SNAT are on the customer edge.  
While we are using this deployment pattern as an example the concepts for other patterns are the same with a few caveats which will be included 
at the end of this article.

.. figure:: ./images/f5xc-deployment-models.png
   :align: center

High Level Concepts
-------------------
Before we discuss the migration phases I want to introduce a few concepts that we will be utilizing.  The first concept is what we call a Virtual Site.  
A virtual Site provides us the ability to perform a given configuration on set (or group) of Sites.  The second term is Origin Pool.  
An origin pool is a mechanism to configure a set of endpoints grouped together into a resource pool used in the load balancer configuration.

The typical CE Site deployment consists of a HA cluster that discovers endpoints via a origin pool picked via the CE Site.
This discovery is typically via Private DNS or RFC-1918 IP ranges all though other methods are available.  
When we introduce the virtual site construct we will perform this discovery via a "Virtual Site" and not the original "CE Site".
As depicted below on the right hand side of the drawing you will see the origin pool is now discovered from all 6 nodes in the virtual site 
and will route traffic to the endpoint per the LB algorithm.  

.. figure:: ./images/site-vs-virtual-site.png 
   :align: center

Also the Virtual Site construct can be utilized for more advanced HA design scenarios and even for additional bandwidth between RE and CE, but this will be discussed in other articles.