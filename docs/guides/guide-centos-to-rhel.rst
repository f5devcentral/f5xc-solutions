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

.. figure:: ./images/f5xc-deployment-model.png
   :width: 500px
   :align: center