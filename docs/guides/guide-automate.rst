.. meta::
   :description: Getting Started with Distributed Cloud Automation
   :keywords: F5, Distributed Cloud, Automation, Terraform
   :category: Field-Sourced-Content
   :sub-category: how-to
   :author: Michael Coleman
   
.. _getting-started-cloud-automation:

Getting Started with Distributed Cloud Automation
=================================================

Cloud automation is a broad and powerful topic that can greatly enhance your IT infrastructure management. This guide will 
help you understand the various levels of automation, from simple scripting to advanced continuous integration/continuous deployment 
(CI/CD) pipelines and infrastructure as code (IaC) tools like Terraform.

Automation Overview
-------------------

Cloud automation involves using scripts and tools to manage cloud resources and services automatically. 
The complexity of your automation can range from basic scripts to comprehensive CI/CD pipelines. 

This guide will cover:

- Getting Started with F5 Distributed Cloud API
- Simple iterative bash scripts
- Advanced Python scripts and Jinja templates
- Prototyping with Postman
- CI/CD pipelines using tools like GitLab, Jenkins, and CircleCI
- Infrastructure as code with Terraform

.. note:: While Ansible is discussed here, its more so because it would be an oversight not to include it.  That said, 
   F5 Distributed Cloud does not currently maintain a module or playbooks for Ansible.  There are some field supported examples
   that may be included.

Getting Started with F5 Distributed Cloud API
---------------------------------------------

All API requests are required to be authenticated using either an API Token or API Certificate. Follow the links below to view instructions on how to obtain an API Token or API Certificate from the F5® Distributed Cloud Console (Console).

* `F5 XC API Getting Started <https://docs.cloud.f5.com/docs/how-to/volterra-automation-tools/apis>`_
* `F5 XC Generating Credentials <https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials>`_

Simple Iterative Bash Scripts
-----------------------------

For those just starting out, automation can be as simple as writing bash scripts. These scripts can iterate through CSV files and use `curl` commands to interact with cloud platform APIs.

By starting with simple bash scripts, you can gradually build your automation skills and move on to more advanced tools and techniques as needed.

**Why Use Bash Scripts for Automation?**

- **Simplicity**: Bash scripts are straightforward and easy to write, making them accessible for beginners.
- **Efficiency**: Automate repetitive tasks to save time and reduce human error.
- **Integration**: Bash scripts can easily integrate with other tools and services, leveraging system utilities and commands.

**Practical Tips for Bash Scripting**:

- **Use Comments**: Add comments to your scripts to explain what each part does. This makes them easier to understand and maintain.
- **Error Handling**: Include error handling to manage unexpected issues gracefully.
- **Modularize**: Break down your scripts into functions for better organization and reusability.
- **Testing**: Test your scripts thoroughly to ensure they work as expected.

Example Script - Create Certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Here is an example of a basic bash script that reads data from a CSV file and uses `curl` to create certificates via an API call.

**Script Explanation**:
- **Reading Data**: The script reads each line from a CSV file.
- **Using `curl`**: It constructs and sends an HTTP POST request for each entry.

.. code-block:: bash

    #!/bin/bash

    # Check if the CSV file is provided as an argument
    if [ -z "$1" ]; then
        echo "Usage: $0 <csv-file>"
        exit 1
    fi

    # Read the CSV file
    while IFS=, read -r namespace certificate_url private_key_location
    do
        # Construct the JSON payload
        payload=$(cat <<EOF
        {
            "metadata": {
                "name": "cert1",
                "namespace": "$namespace"
            },
            "spec": {
                "certificate_url": "$certificate_url",
                "private_key": {
                    "blindfold_secret_info": {
                        "location": "$private_key_location"
                    }
                }
            }
        }
        EOF
        )

        # Send the API request using curl
        response=$(curl -X POST -H 'Content-Type: application/json' \
        -d "$payload" \
        'https://acmecorp.console.ves.volterra.io/api/config/namespaces/ns1/certificates')

        # Print the response
        echo "$response"
    done < "$1"


Example Script - Update Customer Edge Site OS & SW
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This one might seem more advanced, because its longer, but all it really does is reach out for CE site and tell it to upgrade if there is an upgrade available.

.. code-block:: bash

   #!/bin/bash
   
   # Check if the site-name and API Token arguments are provided
   if [ -z "$1" ]; then
       echo "Error: No site-name argument provided."
       echo "Usage: $0 <site-name> <api-token>"
       exit 1
   fi
   
   if [ -z "$2" ]; then
       echo "Error: No API Token argument provided."
       echo "Usage: $0 <site-name> <api-token>"
       exit 1
   fi
   
   # Assign the first and second arguments to variables
   SITE_NAME="$1"
   API_TOKEN="$2"
   
   # Construct the API URL with the site-name
   API_URL="https://<DOMAIN>.console.ves.volterra.io/api/config/namespaces/system/sites/${SITE_NAME}"
   
   # Use curl to fetch the JSON data
   json_data=$(curl -H "Authorization: APIToken ${API_TOKEN}" -s "$API_URL")
   
   # Use jq to extract the information
   version_updates=$(echo "$json_data" | jq -r '.status[] | select(.volterra_software_status != null) | .volterra_software_status | select(.available_version != .deployment_state.version) | .available_version')
   
   # Check if there are version updates
   if [ -z "$version_updates" ]; then
       echo "No version updates found for site $SITE_NAME"
   else
       echo "Version updates for site $SITE_NAME:"
   
       # Loop through each version update
       for version in $version_updates; do
           echo "Update available: $version"
   
           # Construct the POST request body
           post_data="{\"version\":\"$version\"}"
   
           # Replace with the actual POST API endpoint
           POST_API_URL="$API_URL/upgrade_sw"
   
           # Make the POST request
           response=$(curl -s -X POST -H "Authorization: APIToken ${API_TOKEN}" -H "Content-Type: application/json" -d "$post_data" "$POST_API_URL")
   
           echo "Response for version $version:"
           echo "$response"
       done
   fi

Advanced Python Scripting and Jinja Templates
---------------------------------------------

As your automation needs grow, you might find bash scripts limiting. Python offers more advanced capabilities, including better error handling, richer data manipulation, and integration with various libraries. One powerful feature of Python is its support for Jinja templates, which allow for dynamic content generation.

**Why Use Python for Automation?**

- **Advanced Capabilities**: Python supports complex logic, data structures, and libraries, making it suitable for more sophisticated automation tasks.
- **Readability**: Python's syntax is clear and readable, which makes it easier to write and maintain scripts.
- **Extensive Libraries**: A vast ecosystem of libraries is available for various tasks, from HTTP requests (`requests`) to data manipulation (`pandas`).

**Introduction to Jinja Templates**

Jinja is a templating engine for Python, designed to provide a familiar and straightforward way to generate dynamic content:

- **Template Syntax**: Jinja templates use a familiar, Django-inspired syntax for template variables, loops, and conditionals.
- **Separation of Logic and Content**: By using templates, you can separate the content generation logic from the actual content, making your code cleaner and more maintainable.
- **Reusability**: Templates can be reused across different scripts and projects, saving time and effort.

**Advanced Scripting with Python**

As you become more comfortable with Python, you can leverage its advanced features to enhance your automation scripts:

- **Error Handling**: Use try-except blocks to handle errors gracefully and ensure your scripts run smoothly even when encountering issues.
- **Data Manipulation**: Use libraries like `pandas` for advanced data manipulation and analysis.
- **Concurrency**: Use Python's concurrency features (`threading`, `asyncio`) to handle multiple tasks simultaneously, improving the efficiency of your scripts.

Python and Jinja templates provide a powerful combination for automating complex tasks. By leveraging Python's advanced capabilities and the flexibility of Jinja templates, you can create dynamic, maintainable, and scalable automation scripts that go beyond the limitations of simple bash scripts.

For more information on Jinja, visit the `Jinja Documentation <https://jinja.palletsprojects.com/en/3.1.x/intro/>`_.

Example Python Script - Create Certificate
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Prototyping with Postman
------------------------

Postman is an excellent tool for prototyping and validating API models. Its user-friendly interface allows for quick creation, testing, and organization of API requests, making it a great choice for initial development stages.

**Why Use Postman for Prototyping?**

- **Ease of Use**: Postman's graphical interface is intuitive, making it easy to create and test API requests without needing extensive coding knowledge.
- **Templating**: Postman allows you to templatize your API declarations, making it simple to reuse requests with different parameters.
- **Collaboration**: Postman provides features for sharing collections and requests with team members, facilitating collaboration.
- **Environment Management**: You can create multiple environments (e.g., development, testing, production) and switch between them effortlessly.

While Postman is great for prototyping and initial validation, it has limitations for more extensive automation tasks. For infrastructure 
automation and CI/CD integration, more specialized tools are recommended.

**Example Postman Workflow**

1. **Create a Collection**: Organize your API requests into collections for easy access and management.
2. **Define Environment Variables**: Use environment variables to manage different configurations and reuse them across multiple requests.
3. **Write Tests**: Add scripts to your requests to validate responses and automate tests.
4. **Generate Code**: Postman can generate code snippets for various programming languages, which you can use in your automation scripts.

**Limitations for Automation**

Despite its strengths, Postman might not be the best tool for full-scale infrastructure automation:

- **Limited CI/CD Integration**: While Postman can be integrated with CI/CD pipelines, it lacks the flexibility and depth of dedicated tools like Terraform or Ansible.
- **Scalability Issues**: Managing large-scale infrastructure deployments can become cumbersome with Postman.
- **Customization Constraints**: Advanced automation often requires customization and scripting beyond Postman's capabilities.

**Recommended Transition for Automation**

After validating your API models with Postman, consider transitioning to tools better suited for automation and CI/CD workflows:

- **Terraform**: Ideal for managing infrastructure as code, providing a declarative approach to define and provision resources.
- **Ansible**: Excellent for configuration management and application deployment.
- **CI/CD Tools**: Integrate with Jenkins, GitLab, or CircleCI to automate your build, test, and deployment processes.

Example Postman Collection for Several XC Tasks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This collection is owned and maintained by F5 Professional Services and used for customer deployments.

F5 Distributed Cloud - Professional Services Collections: https://www.postman.com/cloudy-astronaut-502658/workspace/f5-distributed-cloud-professional-services-collections/overview


CI/CD Pipelines
---------------

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
-----------------------

For guidance on how to get started with GitLab, follow this link: `GitLab CI/CD QuickStart <https://docs.gitlab.com/ee/ci/quick_start/>`_

Example GitLab CI/CD Pipeline
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
-------------------------------------

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
------------------------------

- `Day 0 Beginners Guide to Terraform <https://jessed-guides.readthedocs.io/en/latest/>`_
- `Terraform Tutorials <https://developer.hashicorp.com/terraform/tutorials>`_
- `F5 Distributed Cloud Terraform Provider <https://registry.terraform.io/providers/volterraedge/volterra/latest>`_

Example Terraform Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
     allow_all_response_codes   = true
     default_anonymization      = true
   
     use_default_blocking_page = true
   }

This configuration creates a Web Application Firewall object.

Example References
------------------

Here are some example references for further exploration:

- `Continuous Integration using GitHub Actions Example (simple) <https://github.com/Mikej81/xc-github-actions-example>`_
- `Deploying F5 Distributed Cloud Application Services <https://github.com/Mikej81/xc-app-services-tf>`_
  - `Route 53 Integration <https://github.com/Mikej81/xc-app-services-tf/tree/modified>`_
  - `Venafi Integration (vesctl wrapper) <https://github.com/Mikej81/xc-app-services-tf/tree/venafi>`_
- `ESXi Automation <https://github.com/Mikej81/f5xcs-vsphere-terraform>`_
- `F5 Distributed Cloud Azure Site Deployment <https://github.com/Mikej81/f5xcs-mcn-tunnel-azure>`_
- `F5 Distributed Cloud AWS Site Deployment <https://github.com/Mikej81/f5xcs-mcn-tunnel-aws>`_
- `F5 Distributed Cloud GCP Site Deployment <https://github.com/Mikej81/f5xcs-multi-region-appstack-gcp>`_

Security Considerations
-----------------------

When automating infrastructure, it is important to adhere to security best practices:

- **API Security**: Always handle API tokens securely. Avoid hardcoding them in scripts; instead, use environment variables 
  or secure secret management solutions.
- **Credential Management**: Use tools like HashiCorp Vault or AWS Secrets Manager to securely store and manage credentials.
- **CI/CD Security**: Implement security scans in your CI/CD pipelines to detect vulnerabilities early. Use tools like SonarQube, 
  Snyk, or OWASP Dependency-Check.

Performance Optimization
------------------------

To optimize the performance of your automated processes:

- **Efficient Scripting**: Write efficient, well-optimized scripts. Avoid unnecessary loops and redundant code.
- **Resource Management**: Monitor and manage resource utilization carefully. Use auto-scaling features provided by your cloud provider.
- **Scaling**: Design your automation processes to scale efficiently with your infrastructure. Use load balancers and distributed systems 
  where appropriate.

Troubleshooting and Best Practices
----------------------------------

Here are some common issues you might encounter during automation, along with their solutions:

- **API Rate Limits**: When hitting API rate limits, implement retries with exponential backoff.
- **Script Errors**: Use robust error handling in your scripts to ensure they fail gracefully.
- **Version Control**: Keep your automation scripts and configurations under version control using Git.

Best practices for writing and maintaining automation scripts include:

- **Modularity**: Write modular scripts that can be reused and combined.
- **Documentation**: Document your scripts and configurations for easier maintenance and onboarding.
- **Testing**: Regularly test your automation processes to catch issues early.

Resources and Further Reading
-----------------------------

- `Postman Learning Center <https://learning.postman.com/>`_
- `Terraform Documentation <https://www.terraform.io/docs>`_
- `Ansible Documentation <https://docs.ansible.com/>`_
- `GitLab CI/CD Documentation <https://docs.gitlab.com/ee/ci/>`_
- `F5 Distributed Cloud Documentation <https://docs.cloud.f5.com/>`_