.. meta::
   :description: Getting Started with Distributed Cloud Automation
   :keywords: F5, Distributed Cloud, Automation, Terraform

.. _getting-started-cloud-automation:

Getting Started with Distributed Cloud Automation
=================================================

Cloud automation is a broad and powerful topic that can greatly enhance your IT infrastructure management. This guide will help you understand the various levels of automation, from simple scripting to advanced continuous integration/continuous deployment (CI/CD) pipelines and infrastructure as code (IaC) tools like Terraform.

Overview
========

Cloud automation involves using scripts and tools to manage cloud resources and services automatically. The complexity of your automation can range from basic scripts to comprehensive CI/CD pipelines. This guide will cover:

- Getting Started with F5 Distributed Cloud API
- Simple iterative bash scripts
- Advanced Python scripts and Jinja templates
- CI/CD pipelines using tools like GitLab, Jenkins, and CircleCI
- Infrastructure as code with Terraform

Getting Started with F5 Distributed Cloud API
=============================================

All API requests are required to be authenticated using either an API Token or API Certificate. Follow the links below to view instructions on how to obtain an API Token or API Certificate from the F5® Distributed Cloud Console (Console).

* `F5 XC API Getting Started <https://docs.cloud.f5.com/docs/how-to/volterra-automation-tools/apis>`_
* `F5 XC Generating Credentials <https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials>`_

Simple Iterative Bash Scripts
=============================

For those just starting out, automation can be as simple as writing bash scripts. These scripts can iterate through CSV files and use `curl` commands to interact with cloud platform APIs.

Example Script
--------------

Here is an example of a basic bash script:

.. code-block:: bash

    #!/bin/bash

    while IFS=, read -r column1 column2 column3
    do
        curl -X POST -H 'Content-Type: application/json' \
        -d '{"metadata":{"name":"cert1","namespace":"'$column1'"},"spec":{"certificate_url":"'$column2'","private_key":{"blindfold_secret_info":{"location":"'$column3'"}}}}' \
        'https://acmecorp.console.ves.volterra.io/api/config/namespaces/ns1/certificates'
    done < data.csv

This script reads data from a CSV file and uses `curl` to make API calls, replacing variables with values from the CSV.

Advanced Python and Jinja Templates
===================================

As your automation needs grow, you might find bash scripts limiting. Python offers more advanced capabilities, including the use of Jinja templates for dynamic content generation.

Example Python Script
---------------------

Here is an example using Python and Jinja2:

.. code-block:: python

   import csv
   import requests
   from jinja2 import Template
   
   template = Template('''
   {
       "metadata": {
           "name": "{{ name }}",
           "namespace": "{{ namespace }}"
       },
       "spec": {
           "certificate_url": "string:///{{ certificate_base64 }}",
           "private_key": {
               "blindfold_secret_info": {
                   "location": "string:///{{ private_key_base64 }}"
               }
           }
       }
   }
   ''')
   
   with open('data.csv') as csvfile:
       reader = csv.DictReader(csvfile)
       for row in reader:
           payload = template.render(
               name=row['name'],
               namespace=row['namespace'],
               certificate_base64=row['certificate_base64'],
               private_key_base64=row['private_key_base64']
           )
           response = requests.post('https://acmecorp.console.ves.volterra.io/api/config/namespaces/ns1/certificates', data=payload)
           print(response.status_code)

This script reads from a CSV file, uses a Jinja template to format the data, and makes API calls with the `requests` library.

CI/CD Pipelines
===============

For more complex automation needs, integrating your scripts into CI/CD pipelines can provide robust and repeatable processes. Tools like GitLab, Jenkins, and CircleCI can help manage these pipelines.

Using a tool like GitLab for Continuous Integration (CI) offers several advantages:

- **Integrated CI/CD Pipelines**: Built-in CI/CD pipelines make it easy to manage build, test, and deployment processes within the same platform.
- **Automation**: Automate tasks like running tests, building applications, and deploying, ensuring consistent and reliable processes.
- **Collaboration**: Facilitates team collaboration with features like merge requests, code reviews, and discussions, enhancing code quality.
- **Security and Compliance**: Includes security scanning for vulnerabilities and helps maintain compliance with industry standards.
- **Traceability**: Provides complete traceability of changes from code commit to deployment, crucial for auditing and debugging.
- **Scalability**: Suitable for projects of all sizes, supporting scalable CI/CD processes as your project grows.
- **Customization**: Highly customizable workflows, stages, and jobs to fit specific needs, supporting various programming languages and frameworks.
- **Integration with Other Tools**: Integrates with Kubernetes, Docker, cloud providers (AWS, Azure, GCP), and more, creating a cohesive ecosystem.
- **Visibility and Reporting**: Offers detailed reports and dashboards on pipeline status, code coverage, and test results.
- **DevOps Culture**: Promotes DevOps practices by integrating development and operations workflows, fostering continuous improvement and agility.

These benefits make GitLab a powerful tool for efficiently managing the entire software development lifecycle.

GitLab CI/CD QuickStart
=======================

For guidance on how to get started with GitLab, follow this link: `GitLab CI/CD QuickStart <https://docs.gitlab.com/ee/ci/quick_start/>`_

Example GitLab CI/CD Pipeline
-----------------------------

Here is an example `.gitlab-ci.yml` file for GitLab CI/CD:

.. code-block:: yaml

    stages:
      - test
      - deploy

    test_job:
      stage: test
      script:
        - echo "Running tests..."
        - python -m unittest discover

    deploy_job:
      stage: deploy
      script:
        - echo "Deploying..."
        - python deploy_script.py

This pipeline runs tests and then deploys your application, ensuring that changes are tested before deployment.

Infrastructure as Code with Terraform
=====================================

For managing cloud infrastructure, Terraform is a powerful tool that allows you to define your infrastructure as code. Terraform configurations are declarative, meaning you define the desired state and Terraform handles the rest.

Using Terraform for infrastructure as code (IaC) brings many advantages:

- **Preexisting Vendor Providers**: Supports a wide range of cloud providers and services (AWS, Azure, GCP, etc.), allowing you to manage infrastructure across multiple platforms with a single tool.
- **Human-Readable Configuration Language (HCL)**: Uses a simple, easy-to-understand syntax that makes writing and maintaining infrastructure configurations straightforward.
- **Infrastructure as Code**: Enables you to define and provision infrastructure using code, which can be versioned, shared, and reused, ensuring consistency and repeatability.
- **Declarative Approach**: Allows you to define the desired state of your infrastructure, and Terraform will handle the steps to achieve that state, simplifying management and reducing the potential for errors.
- **Plan and Apply**: Provides a planning phase (`terraform plan`) to preview changes before applying them, reducing the risk of unintended consequences.
- **State Management**: Maintains a state file that records the current state of your infrastructure, enabling Terraform to track resource changes and dependencies accurately.
- **Modules**: Supports reusable modules, which allow you to encapsulate and share configurations, promoting best practices and reducing duplication.
- **Scalability**: Designed to manage infrastructure of any size, from small projects to large enterprise environments.
- **Community and Ecosystem**: Has a large and active community that contributes modules, providers, and best practices, providing a wealth of resources and support.
- **Integration with CI/CD**: Integrates well with CI/CD pipelines, enabling automated provisioning and management of infrastructure alongside application deployment.

These benefits make Terraform an excellent choice for managing infrastructure efficiently and effectively across diverse environments.

Getting Started with Terraform
==============================

- `Day 0 Beginners Guide to Terraform <https://jessed-guides.readthedocs.io/en/latest/>`_
- `Terraform Tutorials <https://developer.hashicorp.com/terraform/tutorials>`_
- `F5 Distributed Cloud Terraform Provider <https://registry.terraform.io/providers/volterraedge/volterra/latest>`_

Example Terraform Configuration
-------------------------------

Here is an example Terraform configuration:

.. code-block:: hcl

   resource "volterra_app_firewall" "example" {
     name      = "${var.name}-waap"
     namespace = var.namespace
     labels = {
       "ves.io/app_type" = "${var.name}-app-type"
     }
   
     blocking                   = true
     default_detection_settings = true
     default_bot_setting        = true
     allow_all_response codes   = true
     default_anonymization      = true
   
     use_default_blocking_page = true
   }

This configuration creates a Web Application Firewall object.

Example References
==================

Here are some example references for further exploration:

- `Continuous Integration using GitHub Actions Example (simple) <https://github.com/Mikej81/xc-github-actions-example>`_
- `Deploying F5 Distributed Cloud Application Services <https://github.com/Mikej81/xc-app-services-tf>`_
  - `Route 53 Integration <https://github.com/Mikej81/xc-app-services-tf/tree/modified>`_
  - `Venafi Integration (vesctl wrapper) <https://github.com/Mikej81/xc-app-services-tf/tree/venafi>`_
- `ESXi Automation <https://github.com/Mikej81/f5xcs-vsphere-terraform>`_
- `F5 Distributed Cloud Azure Site Deployment <https://github.com/Mikej81/f5xcs-mcn-tunnel-azure>`_
- `F5 Distributed Cloud AWS Site Deployment <https://github.com/Mikej81/f5xcs-mcn-tunnel-aws>`_
- `F5 Distributed Cloud GCP Site Deployment <https://github.com/Mikej81/f5xcs-multi-region-appstack-gcp>`_
